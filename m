Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30510C433EF
	for <linux-trace-devel@archiver.kernel.org>; Sat, 19 Feb 2022 23:02:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236444AbiBSXCV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 19 Feb 2022 18:02:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240183AbiBSXCU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 19 Feb 2022 18:02:20 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 970FCFC6
        for <linux-trace-devel@vger.kernel.org>; Sat, 19 Feb 2022 15:02:00 -0800 (PST)
Received: from localhost ([127.0.0.1] helo=flow.W.breakpoint.cc)
        by Chamillionaire.breakpoint.cc with esmtp (Exim 4.92)
        (envelope-from <sebastian@breakpoint.cc>)
        id 1nLYjl-0000dW-12; Sun, 20 Feb 2022 00:01:57 +0100
From:   Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To:     linux-trace-devel@vger.kernel.org
Cc:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: trace-cmd library: Add ZSTD support.
Date:   Sun, 20 Feb 2022 00:01:50 +0100
Message-Id: <20220219230151.56282-1-sebastian@breakpoint.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Breakpoint-Spam-Score: -1.0
X-Breakpoint-Spam-Level: -
X-Breakpoint-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Steven mentioned that trace-cmd recently gained compression support. I
suggest to remove zlib since there is no real benefit to use this
compression algorithm.
It might make sense to use zstd while dumping the per-CPU data files
disks before the trace.dat is written. It probably makes sense to use
zstd by default instead of storing the .dat file uncompressed.

To put some numbers here:
| time ./tracecmd/trace-cmd convert -i trace-none.dat -o trace-zlib.dat --c=
ompression zlib
| real    9m43,699s
| user    9m41,247s
| sys     0m2,296s
|=20
| time ./tracecmd/trace-cmd convert -i trace-none.dat -o trace-zstd.dat --c=
ompression zstd
| real    0m19,641s
| user    0m17,768s
| sys     0m1,868s
|=20
| time ./tracecmd/trace-cmd convert -i trace-none.dat -o trace-zstd-12.dat =
--compression zstd-12
| real    6m39,731s
| user    6m37,735s
| sys     0m1,908s

The file sizes:
  Name             Human        Bytes (% of the original size)
| trace-none.dat     11G 11240714240
| trace-zlib.dat    1,2G  1257455848 (~11.1%)
| trace-zstd.dat    1,1G  1108957623 (~ 9.9%)
| trace-zstd-12.dat 895M   937466831 (~ 8.3%)

That is why wrote initially that it makes no sense to use zlib: zstd is
approx 29 times faster while the compressed file is even slightly
smaller. The higher zstd compression level (12 used, it goes higher)
makes the even a little smaller the price appears too high.

Sebastian


