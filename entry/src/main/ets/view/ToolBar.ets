import { emitter } from "@kit.BasicServicesKit"

@Builder
function ButtonBuilder(img:string | Resource,id:number,status?:boolean){
  Button({type: ButtonType.Circle}){
    Column(){
      Image(img)
        .width(30)
        .height(30)
    }
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }
  .width(40)
  .height(40)
  .backgroundColor('#fff')
  .enabled(id == 1?status:true)
  .onClick(()=>{
    switch (id){
      case 1:
        emitter.emit("Back")
        break
      case 2:
        emitter.emit("History")
        break
      case 3:
        emitter.emit("AIChat")
        break
      case 4:
        emitter.emit("WebViewManagement")
        break
      case 5:
        emitter.emit("Settings")
        break
    }
  })
}

@Component
export struct ToolBar{
  build() {
    Row(){
      ButtonBuilder($r('app.media.left_arrow_icon'),1,false)
      ButtonBuilder($r('app.media.search_history'),2)
      ButtonBuilder($r('app.media.ai_chat'),3)
      ButtonBuilder($r('app.media.web_view'),4)
      ButtonBuilder($r('app.media.setting'),5)
    }
    .width('100%')
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceAround)
  }
}