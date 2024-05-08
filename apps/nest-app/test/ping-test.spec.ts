import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import * as request from 'supertest';
import { PingModule } from './../src/ping/ping.module';

describe('PingController (e2e)', () => {
  let ping: INestApplication;

  beforeEach(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [PingModule],
    }).compile();

    ping = moduleFixture.createNestApplication();
    await ping.init();
  });
  const response ={
    status: 200,
    message: "Ping Successful!!",
  };

  it('/ping (GET)', () => {
    return request(ping.getHttpServer())
      .get('/ping')
      .expect(200)
      .expect(JSON.stringify(response));
  });
});
