Return-Path: <SRS0=L246=YS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 550E2CA9EAF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Oct 2019 00:45:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FFF721D71
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Oct 2019 00:45:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ikerlan.es header.i=@ikerlan.es header.b="GfFbhk64"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730650AbfJYApC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 24 Oct 2019 20:45:02 -0400
Received: from mail-eopbgr60102.outbound.protection.outlook.com ([40.107.6.102]:62669
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727108AbfJYApC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 24 Oct 2019 20:45:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lugwosY9QcEtdy317ChH2hJQpUD7DJov6XOVFZf11b+HQqatU794NpZCxNHxJ/cOZscaBJj/Qbko2GLQgdYPk7SbBqCwainmVE/7THvxs5wQPUdrCn8YvulSgLPC8ZmKp5N1UyxiiJAAarmlO0p8hKJj8HDVN8uhrWzu1asQWiXnY3u6SN14qGex0lQeEES6gY9J5nu5C90wgx6ce6/xei+HOyjs8BBu42Nu1tvT0LNwy/xZCk8vujxtxdIyubZz3H0/FNO/w8cS0o3Lw2NNPPbRlYckzxNIYy8gUnU2Gw5/yLGDS2NgRIi9PhlpmIYpmLewjYgP65At7lsFLmZ8UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mtwTv6UnDe++LuK1wmDU1xJ3Lg6Emj0pgS9nzWc0EDk=;
 b=bYeL/HRbV6jSjamR5HD5+izYMCLX8ucWyeNu8ZL7xjfAj6LhrpLdzJgQvM6Z5BrxUGpJKLzl7Y1z7g9UzRlr2A34ZzkYxb4hsVluyZc1ETRz77TGpfpKLEuwj2TwRXt7DqI6ZBElVtA7LR8Q8695CEEZH3WWrrZ1HCEiHlQbYncvRV4SRtmpeZlVQOmDjO45f4TTA3FNtdyAyBraDCI0RpBOjoRKIfq7Bk28R1vpxTfarkgSLMK5GOYZUzH93nbnJP4FdzknbAxhIL5aiTt6Taui1F8GXRn+Y09W0RiwMzQM6KWB6x24hlDkZPOsASRjyIQG3KkjpmrWVnU2/clicg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ikerlan.es; dmarc=pass action=none header.from=ikerlan.es;
 dkim=pass header.d=ikerlan.es; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ikerlan.es;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mtwTv6UnDe++LuK1wmDU1xJ3Lg6Emj0pgS9nzWc0EDk=;
 b=GfFbhk64h07NDz5BnHnvmuxnXd4jdI6X6YDK52K+Ej8Byy+uSu6Ta1iLQPjgNC23P427956WtIemEYqfvaarx7qx9s2Og1uqb6MLrdRmAURMcf57OZ+52UcnmTg+h/oDrVxbnVESNdVcgIWdxFKBjgYibq3j67lmkysnqOLn07I=
Received: from DB8PR03MB5897.eurprd03.prod.outlook.com (10.255.19.87) by
 DB8PR03MB5706.eurprd03.prod.outlook.com (20.179.249.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.25; Fri, 25 Oct 2019 00:44:57 +0000
Received: from DB8PR03MB5897.eurprd03.prod.outlook.com
 ([fe80::9c6d:a8a7:767:11b7]) by DB8PR03MB5897.eurprd03.prod.outlook.com
 ([fe80::9c6d:a8a7:767:11b7%3]) with mapi id 15.20.2387.025; Fri, 25 Oct 2019
 00:44:56 +0000
From:   Allende Imanol <iallende@ikerlan.es>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>
Subject: RE: Deadlock with FTrace in child process
Thread-Topic: Deadlock with FTrace in child process
Thread-Index: AdWGT9K7x4C80Ow0SbmpnA6CSDVwYgBzcgWAAKvuONA=
Date:   Fri, 25 Oct 2019 00:44:56 +0000
Message-ID: <DB8PR03MB589769D8EFD0DCE8AEC6D283B6650@DB8PR03MB5897.eurprd03.prod.outlook.com>
References: <DB8PR03MB5897244BE1F37E6A001C300FB66F0@DB8PR03MB5897.eurprd03.prod.outlook.com>
 <20191021104121.769f3162@gandalf.local.home>
In-Reply-To: <20191021104121.769f3162@gandalf.local.home>
Accept-Language: es-ES, en-US
Content-Language: es-ES
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=iallende@ikerlan.es; 
x-originating-ip: [219.246.34.56]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6f985474-9ed9-4c10-60d6-08d758e48ee9
x-ms-traffictypediagnostic: DB8PR03MB5706:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <DB8PR03MB57061B701C9E6B0390DCB561B6650@DB8PR03MB5706.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02015246A9
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(39840400004)(376002)(346002)(396003)(136003)(189003)(199004)(186003)(26005)(6506007)(476003)(102836004)(25786009)(486006)(446003)(11346002)(33656002)(966005)(478600001)(14454004)(66066001)(86362001)(5660300002)(52536014)(66476007)(66446008)(64756008)(66556008)(76116006)(7696005)(66946007)(76176011)(99286004)(8936002)(6116002)(4326008)(3846002)(71190400001)(6916009)(74316002)(54906003)(316002)(71200400001)(7736002)(14444005)(305945005)(256004)(6306002)(6246003)(9686003)(8676002)(55016002)(81156014)(6436002)(2906002)(229853002)(81166006);DIR:OUT;SFP:1102;SCL:1;SRVR:DB8PR03MB5706;H:DB8PR03MB5897.eurprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: ikerlan.es does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lGwTn77ROY0zxqhyD3zofWJb1h6YMSvlUxDHvrYm+Bjck8WUmnFhNVB+uifEN/e6Pvo3VF4UBedf8cPE64R4lDTN7qbKlcuUbIb1CGK9kT5ipBcR9aZontVs1HtTzjvJg6bwcnHAqY29Q6xiNo4/Lbvl08PAuc8RVRRstLwbDEfBMphkvUBkL8xoSwdNd2g8DxekNlSUVhlW67VLUf1tBulBE72oCfuSRrvw7P4+SWuirLa3o0vTucWX+062ps1iQqjcMNWZw5JXrNHszwRSYgTE8dpDyORMAYgdKOGN579YTFlRAL8JK6WOiXjq9veaBvlWW65rsfAZANRNIOrcrR9GjAoeWyuVyhjLjJ1EJ17hD+/ht2t4j8V3jg0iOhrmNcE5KTbLImUdooBX8AuFhq8FLbbOnCHEscfpOHawlIcMpGMCwBLqVWN0IUkcQOfq0wA2sRU4y6q6cbQdOpcerUFkQF/tuzm1r+zi8TAV1OM=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: ikerlan.es
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f985474-9ed9-4c10-60d6-08d758e48ee9
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2019 00:44:56.8572
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 910ac815-f855-4a08-bf29-90b46552cf11
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T1ACm6FRqGTmfQm60G6wK/1w5MGG1nhQxWyf1wPyVZKdMFVpfgSwby/adGqBiV+LiEKp62BAHb9m7rV6rgdKLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR03MB5706
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

> On Sat, 19 Oct 2019 07:50:53 +0000
> Allende Imanol <iallende@ikerlan.es> wrote:
>=20
> > I am using Ftrace in a Ultra96 (arm64) 4.19.75-cip11 and it seems that
> > I have a deadlock situation. I have a simple application executed as a
> > child process from a python script. The child process reads from
> > /dev/urandom and writes in /dev/zero. Ftrace is set only for this child
> > process.
>=20
> Are you saying that ftrace is calling the blocked task?
>=20
> If you don't run ftrace, the task never gets stuck?

Without FTrace I did not get to achieve the same stuck scenario.

>=20
>=20
> >
> > After thousands of executions of the child process with a high IRQ and
> > CPU load (it varies in the number but it is quite reproducible) - the c=
hild
> > process gets blocked. But the system still is running.
> >
> > The child process appears as "sleeping state" and if I try to do kill
> > -18 $pid it does not change.
> >
> > In this case the child process is 4197 PID.
> >
> > # ps -aux | grep python
> > root      1145  6.3  0.4  85448  9508 ?        S<l  00:00  23:02 python=
3 test_client.py
> > root      4197  0.0  0.4  85448  8256 ?        S<   05:53   0:00 python=
3 test_client.py
> > root      5279  0.0  0.0   2752   280 ttyPS0   S+   06:02   0:00 grep p=
ython
> > # cat /proc/4197/stack
> > [<0>] __switch_to+0x94/0xd0
> > [<0>] futex_wait_queue_me+0xd0/0x150
> > [<0>] futex_wait+0x12c/0x200
> > [<0>] do_futex+0x304/0xc10
>=20
> Looks like the task is blocked on a user space mutex (futex).
>=20
> > [<0>] __arm64_sys_futex+0x154/0x190
> > [<0>] el0_svc_common+0xa0/0x170
> > [<0>] el0_svc_handler+0x38/0x80
> > [<0>] el0_svc+0x8/0xc
> > [<0>] 0xffffffffffffffff
> >

I could reproduce it in my Intel laptop (Debian 10 - 4.19 kernel):
# cat /proc/21719/stack=20
[<0>] futex_wait_queue_me+0xc1/0x120
[<0>] futex_wait+0x13f/0x240
[<0>] do_futex+0x3f7/0xbf0
[<0>] __x64_sys_futex+0x143/0x180
[<0>] do_syscall_64+0x53/0x110
[<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[<0>] 0xffffffffffffffff

> >
> > The stack is more or less the same every time the block happens.
> >
> > If I kill -9 the child process the execution loop will continue with
> > spawning the next child so it seems that the deadlock is really only
> > in the child process - but do not know why.
> >
> > I am using function_graph traces and I added the funcgraph-proc,
> > noirq-info and nofuncgraphs-irq options. I disable tracing after each
> > iteration, and I clear the trace buffer and pid set also.
> >
> > I add the application that is executed as the child process:
>=20
> I don't understand what you meant by this. Is the below the code that
> gets stuck? But the above shows a python task?

The python script executes the read/write application as a child process

>=20
> >
> > #define DEV1 "/dev/urandom"
> > #define DEV2 "/dev/null"
> >
> > int main(int argc, char **argv)
> > {
> >  unsigned char result;
> >  int fd1, fd2, ret;
> >  char res_str[10] =3D {0};
> >
> >  fd1 =3D open(DEV1, O_RDONLY);
> >  fd2 =3D open(DEV2, O_WRONLY);
> >
> >  ret =3D read(fd1, &result, 1);
> >  sprintf(res_str, "%d", result);
> >  ret =3D write(fd2, res_str, strlen(res_str));
> >
> >  close(fd1);
> >  close(fd2);
> >
> >  return ret;
> > }
>=20
> Can you give the full reproducer, and explain the problem in a bit more
> detail. I don't really see how ftrace is involved here, besides that
> you are running it.

This is a part of a bigger trace analysis tool that we are still developing=
.=20
https://sil2.osadl.org/download/DB4SIL2_client.tar.gz

It is ready to execute in Intel based computer. To execute the tool:
# python3 test_client.py

The tool starts executing hackbench, to disable it, just comment first 2
lines of test_client_code()

There is a README with more detailed in explanation

>=20
> -- Steve
>=20
> >
> > The preemption configuration is set to Preemptible kernel and the Ftrac=
e
> > config is set:
> > CONFIG_FTRACE=3Dy
> > CONFIG_FUNCTION_TRACER=3Dy
> > CONFIG_FUNCTION_GRAPH_TRACER=3Dy
> > # CONFIG_PREEMPTIRQ_EVENTS is not set
> > # CONFIG_IRQSOFF_TRACER is not set
> > # CONFIG_PREEMPT_TRACER is not set
> > # CONFIG_SCHED_TRACER is not set
> > # CONFIG_HWLAT_TRACER is not set
> > CONFIG_FTRACE_SYSCALLS=3Dy
> > # CONFIG_TRACER_SNAPSHOT is not set
> > CONFIG_BRANCH_PROFILE_NONE=3Dy
> > # CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
> > # CONFIG_PROFILE_ALL_BRANCHES is not set
> > CONFIG_STACK_TRACER=3Dy
> > # CONFIG_BLK_DEV_IO_TRACE is not set
> > CONFIG_UPROBE_EVENTS=3Dy
> > CONFIG_PROBE_EVENTS=3Dy
> > CONFIG_DYNAMIC_FTRACE=3Dy
> > # CONFIG_FUNCTION_PROFILER is not set
> > CONFIG_FTRACE_MCOUNT_RECORD=3Dy
> > # CONFIG_FTRACE_STARTUP_TEST is not set
> > # CONFIG_HIST_TRIGGERS is not set
> > # CONFIG_TRACEPOINT_BENCHMARK is not set
> > # CONFIG_RING_BUFFER_BENCHMARK is not set
> > # CONFIG_RING_BUFFER_STARTUP_TEST is not set
> > # CONFIG_PREEMPTIRQ_DELAY_TEST is not set
> > # CONFIG_TRACE_EVAL_MAP_FILE is not set
> > CONFIG_TRACING_EVENTS_GPIO=3Dy

