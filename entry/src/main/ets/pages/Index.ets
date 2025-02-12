import { promptAction, window } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { ToolBar } from '../view/ToolBar';
import { BusinessError, emitter } from '@kit.BasicServicesKit';

@Entry
@Component
struct Index {
  @State SearchMessage: string = '';
  @State keyboardHeight:number = 0;
  @State ShowSearchResult:boolean = false;
  // 当前的搜索引擎
  @StorageLink("EngineIndex") currentEngineIndex:number = 0
  @StorageLink("EngineName") currentEngineName:string = 'Bing'

  @Provide("NavPageStack") PageStack:NavPathStack = new NavPathStack()
  // 当前窗口对象
  private windowClass:window.Window | undefined = undefined

  aboutToAppear(): void {
    this.RegisterEmit()
    //开启软键盘高度变化的监听
    window.getLastWindow(getContext(this), (err, data) => {
      if (err) {
        hilog.error(0x00,"Index_Print",`获取当前窗口出错 code = ${err.code}  message = ${err.message}`)
      }
      this.windowClass = data
      this.windowClass.on("keyboardHeightChange", (data) => {
        this.keyboardHeight =  data
        hilog.info(0x00,"Index_Print",`当前窗口高度为 keyboardHeight = ${this.keyboardHeight}`)
      })
    })
  }
  aboutToDisappear(): void {
    this.CloseEmit()
  }

  build() {
    Navigation(this.PageStack){
      RelativeContainer() {
        if (!this.ShowSearchResult){
          Image($r('app.media.AppLogo'))
            .width('60%')
            .height('30%')
            .borderRadius(500)
            .alignRules({
              center: { anchor: '__container__', align: VerticalAlign.Center },
              middle: { anchor: '__container__', align: HorizontalAlign.Center }
            })
            .offset({y:'-10%'})
            .visibility(this.keyboardHeight?Visibility.Hidden:Visibility.Visible)
          Search({placeholder: "请输入搜索内容...", value: $$this.SearchMessage})
            .id('Search')
            .width('80%')
            .height('5%')
            .alignRules({
              center: { anchor: '__container__', align: VerticalAlign.Center },
              middle: { anchor: '__container__', align: HorizontalAlign.Center }
            })
            .offset(this.keyboardHeight?{y: 0}:{y:'10%'})
        }else {
        }
        ToolBar()
          .alignRules({
            bottom: {anchor: "__container__", align: VerticalAlign.Bottom}
          })
          .offset(this.keyboardHeight?{y: -this.keyboardHeight + 80 + 'px'}:{})
      }
      .width('100%')
      .height('100%')
    }
    .hideTitleBar(true)
    .hideToolBar(true)
  }

  // 集中注册线程通信监听器
  RegisterEmit(){
    emitter.on("Back",()=>{})
    emitter.on("History",()=>{})
    emitter.on("AIChat",()=>{})
    emitter.on("WebViewManagement",()=>{})
    emitter.on("Settings",()=>{
      this.PageStack.pushPathByName("SettingPage",null)
    })
  }
  CloseEmit(){
    emitter.off("Back")
    emitter.off("History")
    emitter.off("AIChat")
    emitter.off("WebViewManagement")
    emitter.off("Settings")
  }
}