Return-Path: <SRS0=KbUX=YM=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 364DACA9EAC
	for <linux-trace-devel@archiver.kernel.org>; Sat, 19 Oct 2019 07:51:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9B36222CC
	for <linux-trace-devel@archiver.kernel.org>; Sat, 19 Oct 2019 07:51:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ikerlan.es header.i=@ikerlan.es header.b="PFaTLv3Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725940AbfJSHvl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 19 Oct 2019 03:51:41 -0400
Received: from mail-eopbgr70115.outbound.protection.outlook.com ([40.107.7.115]:58853
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725877AbfJSHvl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 19 Oct 2019 03:51:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OqDoIGTjrk3lCuMjH44p6bIIITUCDVyJ9pxJjiK6ikW/2tpuWvp9XmVMoJAGZKHamsm7O3jDr5goUbARK/itKrq8Rk0VpKEIj72gExJUQUsNu1Cx5vK0inWEsH3t/iBtrJK0wy0vxze2jjdtNocs4GBMN0Mn9T3ckg6H+HHKwaXUPKEXHcKCv4eUAkNYk62mrmRMX2jzea2GclTSUQFq40/3hl9igy1ABrD49dhXU2u7RsmDmElV6eLyOiJCnmsv3RUryPnjh0UURTtBxcnlCg/s+1NOy1K/cyNTszshYIseP/SUMHLBAlsFrjptwCHYxT7WXSenLVcaW3GwC7XNeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4fiJ48JYQnaumY09hXX0wc6cOd6LaOMd1AjMpEwjKq8=;
 b=XGoFwGxt/ko+IcBbKJXKDnE6Tsf0dWjOKXa0ACsatkwhabyMSg8diV1g7KyBhilVVWItsBuBQzhNuznJJG2DyUaLZqA6p89UwPmwDpCrbFn1OOL0/8EefPWvR91UP9vuuF8xpkS8kEhFA14VOpankxcY68HLJhtDyytAYSJ0Lb2lfP5lhXFRQnD5Y/CRwRWD0iOI8DoMSjve8jBk804jk4gxAHCbyXDIFbDVXMkuzRrHXuainOlZESg+ppiFh5gAqVAauO4RlFgrhKzNV3xLWPIt6O14R42EyN6xBoLrWVN9D/Elufnm77MD9sR09LbDq8KsImCoNrk8lyUNuQ56Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ikerlan.es; dmarc=pass action=none header.from=ikerlan.es;
 dkim=pass header.d=ikerlan.es; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ikerlan.es;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4fiJ48JYQnaumY09hXX0wc6cOd6LaOMd1AjMpEwjKq8=;
 b=PFaTLv3ZPJa+o/GvzX6T3kcYiNEpWYgoHWIM4jIpxSBsioY9ByHUgF5FoN2zoG6etzRP/4CiMBgcDoMf51pJ3qTWBlWlW1letii1PheZnz0poiEt7ndPIrl64cJCBvRPi4rgR6JXZTaWp3R6gRh+MQL6cFx9CkF2yr6GROQUJ+w=
Received: from DB8PR03MB5897.eurprd03.prod.outlook.com (10.255.19.87) by
 DB8PR03MB6331.eurprd03.prod.outlook.com (10.186.164.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.23; Sat, 19 Oct 2019 07:50:54 +0000
Received: from DB8PR03MB5897.eurprd03.prod.outlook.com
 ([fe80::9c6d:a8a7:767:11b7]) by DB8PR03MB5897.eurprd03.prod.outlook.com
 ([fe80::9c6d:a8a7:767:11b7%3]) with mapi id 15.20.2347.028; Sat, 19 Oct 2019
 07:50:54 +0000
From:   Allende Imanol <iallende@ikerlan.es>
To:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
CC:     "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "mingo@kernel.org" <mingo@kernel.org>
Subject: Deadlock with FTrace in child process
Thread-Topic: Deadlock with FTrace in child process
Thread-Index: AdWGT9K7x4C80Ow0SbmpnA6CSDVwYg==
Date:   Sat, 19 Oct 2019 07:50:53 +0000
Message-ID: <DB8PR03MB5897244BE1F37E6A001C300FB66F0@DB8PR03MB5897.eurprd03.prod.outlook.com>
Accept-Language: es-ES, en-US
Content-Language: es-ES
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=iallende@ikerlan.es; 
x-originating-ip: [219.246.34.56]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8470a712-75e8-41f8-7586-08d75469119d
x-ms-traffictypediagnostic: DB8PR03MB6331:
x-microsoft-antispam-prvs: <DB8PR03MB63318BB868CBF9C2F6ADADFBB66F0@DB8PR03MB6331.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 01952C6E96
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(366004)(346002)(136003)(396003)(39840400004)(189003)(199004)(76116006)(66946007)(316002)(66556008)(66446008)(66476007)(64756008)(5660300002)(2501003)(54906003)(52536014)(6506007)(71190400001)(71200400001)(7696005)(186003)(102836004)(66066001)(14454004)(26005)(14444005)(256004)(478600001)(6916009)(99286004)(33656002)(5640700003)(2906002)(9686003)(6436002)(55016002)(2351001)(7736002)(4326008)(486006)(476003)(3846002)(6116002)(81156014)(81166006)(8936002)(86362001)(8676002)(305945005)(25786009)(74316002);DIR:OUT;SFP:1102;SCL:1;SRVR:DB8PR03MB6331;H:DB8PR03MB5897.eurprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: ikerlan.es does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: X5WDh0j6f6hv+y95fPI8NwIh+n1ebn8pdlOaXZRdzaeVa/wpfYWv5UhqHYvEaulGDMFhjBRrj/Zch8slI54uCX4YeTIYhcg/Llbtak2zwxD+DrsIcnEDf0VoBhVeJ7qkd4Bm/qYZxCTUxiao6xUl2mu535Rl/TkO9NCfLiq14K97GVBVgpklbdU14sILnOsXc95L0QhTeCZSTbt+WRBKmWx96mh5dARXkh53mnu4icN+yIR5IoSYgMOxzhMCHsIkMmUTLG8EUDm6R8Rsl49S1u+tmbDdlyyTeiloIIi5DnnPMiPH77Tn0kFJ0KrwWIpSeDj0nvwy9/AABBTpYnX6lrSiYTIPZFONoOn4IAtUVWH4YlarvV8aABu5pvGhaftam2Ryg5anrMrHUxug2WE6YLCGV1aBvD2s1MM+jVqMRS4=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: ikerlan.es
X-MS-Exchange-CrossTenant-Network-Message-Id: 8470a712-75e8-41f8-7586-08d75469119d
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2019 07:50:53.8636
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 910ac815-f855-4a08-bf29-90b46552cf11
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y8EEEKUV4Yk6bPsOFS84etTU1uYH/NQ2bQghtXaLdK4aR1MOKnXqleHhjB/xhL+9+F+TJti638qfH4hoWuOFdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR03MB6331
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

I am using Ftrace in a Ultra96 (arm64) 4.19.75-cip11 and it seems that
I have a deadlock situation. I have a simple application executed as a
child process from a python script. The child process reads from
/dev/urandom and writes in /dev/zero. Ftrace is set only for this child
process.

After thousands of executions of the child process with a high IRQ and
CPU load (it varies in the number but it is quite reproducible) - the child
process gets blocked. But the system still is running.

The child process appears as "sleeping state" and if I try to do kill
-18 $pid it does not change.

In this case the child process is 4197 PID.

# ps -aux | grep python
root      1145  6.3  0.4  85448  9508 ?        S<l  00:00  23:02 python3 te=
st_client.py
root      4197  0.0  0.4  85448  8256 ?        S<   05:53   0:00 python3 te=
st_client.py
root      5279  0.0  0.0   2752   280 ttyPS0   S+   06:02   0:00 grep pytho=
n
# cat /proc/4197/stack
[<0>] __switch_to+0x94/0xd0
[<0>] futex_wait_queue_me+0xd0/0x150
[<0>] futex_wait+0x12c/0x200
[<0>] do_futex+0x304/0xc10
[<0>] __arm64_sys_futex+0x154/0x190
[<0>] el0_svc_common+0xa0/0x170
[<0>] el0_svc_handler+0x38/0x80
[<0>] el0_svc+0x8/0xc
[<0>] 0xffffffffffffffff


The stack is more or less the same every time the block happens.

If I kill -9 the child process the execution loop will continue with
spawning the next child so it seems that the deadlock is really only
in the child process - but do not know why.

I am using function_graph traces and I added the funcgraph-proc,
noirq-info and nofuncgraphs-irq options. I disable tracing after each=20
iteration, and I clear the trace buffer and pid set also.

I add the application that is executed as the child process:

#define DEV1 "/dev/urandom"
#define DEV2 "/dev/null"

int main(int argc, char **argv)
{
 unsigned char result;
 int fd1, fd2, ret;
 char res_str[10] =3D {0};

 fd1 =3D open(DEV1, O_RDONLY);
 fd2 =3D open(DEV2, O_WRONLY);

 ret =3D read(fd1, &result, 1);
 sprintf(res_str, "%d", result);
 ret =3D write(fd2, res_str, strlen(res_str));

 close(fd1);
 close(fd2);

 return ret;
}

The preemption configuration is set to Preemptible kernel and the Ftrace
config is set:
CONFIG_FTRACE=3Dy
CONFIG_FUNCTION_TRACER=3Dy
CONFIG_FUNCTION_GRAPH_TRACER=3Dy
# CONFIG_PREEMPTIRQ_EVENTS is not set
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_PREEMPT_TRACER is not set
# CONFIG_SCHED_TRACER is not set
# CONFIG_HWLAT_TRACER is not set
CONFIG_FTRACE_SYSCALLS=3Dy
# CONFIG_TRACER_SNAPSHOT is not set
CONFIG_BRANCH_PROFILE_NONE=3Dy
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_STACK_TRACER=3Dy
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_UPROBE_EVENTS=3Dy
CONFIG_PROBE_EVENTS=3Dy
CONFIG_DYNAMIC_FTRACE=3Dy
# CONFIG_FUNCTION_PROFILER is not set
CONFIG_FTRACE_MCOUNT_RECORD=3Dy
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_HIST_TRIGGERS is not set
# CONFIG_TRACEPOINT_BENCHMARK is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set
# CONFIG_PREEMPTIRQ_DELAY_TEST is not set
# CONFIG_TRACE_EVAL_MAP_FILE is not set
CONFIG_TRACING_EVENTS_GPIO=3Dy

