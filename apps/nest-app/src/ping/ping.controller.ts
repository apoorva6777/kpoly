import { Controller, Get, Response, HttpCode, Header, HttpStatus} from '@nestjs/common';
import { PingService } from './ping.service';
import { Response as Res } from 'express';

@Controller()
export class PingController {
  constructor(private readonly pingService: PingService) {}
  @Get('/api/test')
  getPing(@Response() res: Res): Res {
    return this.pingService.getPing(res);
  }
}



