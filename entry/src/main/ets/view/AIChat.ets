import axios from '@ohos/axios';
import { BusinessError } from '@kit.BasicServicesKit';

@Builder
export function AIChatBuilder(){
  AIChat()
}

@Entry
@Component
struct AIChat {
  @State messages: Message[] = [];
  @State userInput: string = "";
  @State isLoading: boolean = false;

  // 自定义弹窗
  dialog = new CustomDialogController({
    builder: LoadingDialog(),
    customStyle: true,
    alignment: DialogAlignment.Center,
    maskColor: '#00000000'
  })

  build() {
    NavDestination(){
      Column() {
        // 聊天记录展示
        List() {
          ForEach(this.messages, (msg:Message, index) => {
            ListItem(){
              Column(){
                Text(`${msg.role === "user" ? "🧑 你：" : "🤖 Google Gemini："}`)
                  .fontWeight(FontWeight.Bold)
                  .margin({ top: 5 })

                Text(msg.content)
                  .textAlign(TextAlign.Start)
                  .padding(10)
                  .backgroundColor(msg.role === "user" ? "#D1E8FF" : "#E3E3E3")
                  .borderRadius(8)
                  .margin({ bottom: 10 })
              }
              .width('100%')
            }
          })
        }
        .width('100%')
        .height('90%')

        // 输入框 + 发送按钮
        Row({space:10}) {
          TextInput({ placeholder: "请输入你的问题...", text: $$this.userInput })
            .width('70%')
            .height(50)
            .padding(10)
            .borderRadius(8)
            .borderWidth(1)
            .borderColor("#999")
            .onSubmit(() => this.sendMessage())

          Button("发送")
            .width('20%')
            .height(50)
            .backgroundColor("#007AFF")
            .fontColor("#FFF")
            .onClick(() => this.sendMessage())
            .enabled(!this.isLoading) // 正在加载时禁用
        }
        .width('100%')
        .height(60)
        .padding(10)
        .justifyContent(FlexAlign.Center)
      }
      .width('100%')
      .height('100%')
    }
    .hideTitleBar(true)
    .hideToolBar(true)
  }

  async sendMessage() {
    if (this.userInput.trim() === "" || this.isLoading) return;

    // 添加用户消息
    this.messages.push({ role: "user", content: this.userInput });
    let userMessage = this.userInput;
    this.userInput = ""; // 清空输入框
    this.isLoading = true;

    try {
      this.dialog.open()
      let response = await callDeepSeekAPI(userMessage)

      if (typeof(response) != "string") {
        let aiResponse = response.choices[0]?.message?.content || "AI 未返回消息";
        this.messages.push({ role: "assistant", content: aiResponse });
      } else {
        this.messages.push({ role: "assistant", content: "请求失败，请稍后重试。" });
      }
    } catch (error) {
      this.messages.push({ role: "assistant", content: "网络错误，请检查你的连接。" });
    } finally {
      this.isLoading = false;
      this.dialog.close()
    }
  }
}

interface Message {
  role: string;
  content: string;
}
interface OpenAIResponse {
  id: string;
  object: string;
  created: number;
  model: string;
  provider: string;
  system_fingerprint: string;
  choices: Choices[];
  usage: Usage;
}
interface Choices{
  index: number;
  message: Message;
  finish_reason: string
}
interface Usage{
  prompt_tokens: number;
  completion_tokens: number;
  total_tokens: number
}

// 调用 Google Gemini 对话 API
async function callDeepSeekAPI(question: string) {
  const API_URL = 'https://gemini-user.nesslin.us.kg';

  // 1. 创建 HTTP 请求对象
  let Axios = axios.create()

  // 2. 构造请求参数
  let params: Record<string, Object> = {
    'messages': [
      { role: "user", content: question } as Message
    ]
  };

  // 3. 设置请求头
  let headers: Record<string, string> = {
    'Content-Type': 'application/json'
  };

  // 4. 发送 POST 请求
  try {
    let res = await Axios.post(API_URL,params,{headers:headers}) as object

    // 5. 处理响应
    if (res["status"] === 200) {
      let data = res["data"] as OpenAIResponse
      return data
    } else {
      console.error(`OpenAIChat Error: `);
      return "请求失败，请检查 API 状态";
    }
  } catch (error) {
    let err = error as BusinessError;
    console.error(`网络请求异常: ${err.code} - ${err.message}`);
    return "网络连接异常";
  }
}

@CustomDialog
struct LoadingDialog {
  message: string = '正在思考中...'
  controller: CustomDialogController

  build() {
    Column({ space: 10 }) {
      LoadingProgress()
        .width(48)
        .height(48)
        .color('#fff')
      if (this.message) {
        Text(this.message)
          .fontSize(14)
          .fontColor('#fff')
      }
    }
    .justifyContent(FlexAlign.Center)
    .width(120)
    .height(120)
    .backgroundColor('rgba(0,0,0,0.6)')
    .borderRadius(16)
  }
}