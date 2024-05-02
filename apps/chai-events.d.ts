declare module 'chai-events' {
    import { EventMatcher } from 'chai';
  
    interface ChaiEvents {
      emit(eventName: string, ...args: any[]): EventMatcher;
    }
  
    function chaiEvents(chai: any, utils: any): void;
  
    export = chaiEvents;
  }
  