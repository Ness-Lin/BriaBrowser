import { emitter } from "@kit.BasicServicesKit";

@Builder
export function SettingBuilder(){
  Setting()
}

@Component
export struct Setting{
  @State searchEngine:SelectOption[] = [
    {value: "Bing"},
    {value: "Google"},
    {value: "百度"}
  ];
  @StorageLink("EngineIndex") currentEngineIndex:number = 0
  @StorageLink("EngineName") currentEngineName:string = 'Bing'
  build() {
    NavDestination(){
      Column(){
        Row(){
          Text("搜索引擎")
            .fontColor('#000')
          Select(this.searchEngine)
            .selected(this.currentEngineIndex)
            .value(this.currentEngineName)
            .onSelect((index: number, value: string) => {
              this.currentEngineIndex = index
              this.currentEngineName = value
            })
        }
        .width('100%')
        .height('10%')
        .justifyContent(FlexAlign.SpaceBetween)
        Divider()
          .width('100%')
          .height(2)

        Row(){
          Text("清除历史记录")
            .fontColor('#000')
          Image("")
            .width(15)
            .aspectRatio(1)
        }
        .width('100%')
        .height('10%')
        .justifyContent(FlexAlign.SpaceBetween)
        Divider()
          .width('100%')
          .height(2)

        Row(){
          Text("颜色模式")
            .fontColor('#000')
          Image($r('app.media.next'))
            .width(15)
            .aspectRatio(1)
        }
        .width('100%')
        .height('10%')
        .justifyContent(FlexAlign.SpaceBetween)
        Divider()
          .width('100%')
          .height(2)

        Row(){
          Text("关于我们")
            .fontColor('#000')
          Image($r('app.media.next'))
            .width(15)
            .aspectRatio(1)
        }
        .width('100%')
        .height('10%')
        .justifyContent(FlexAlign.SpaceBetween)
        Divider()
          .width('100%')
          .height(2)
      }
      .width('100%')
      .height('100%')
      .alignItems(HorizontalAlign.Start)
      .padding({left:20,right:20})
      .margin({top:20})
    }
    .hideTitleBar(true)
    .hideToolBar(true)
  }
}