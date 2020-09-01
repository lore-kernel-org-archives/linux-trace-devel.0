Return-Path: <SRS0=43n+=CK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7C33C433E6
	for <linux-trace-devel@archiver.kernel.org>; Tue,  1 Sep 2020 22:11:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77D74206F0
	for <linux-trace-devel@archiver.kernel.org>; Tue,  1 Sep 2020 22:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598998306;
	bh=/F1vhAW8eEW/niSrMCLIxso0TGb0/c4qmJMSoVaUS9s=;
	h=Date:From:To:Cc:Subject:List-ID:From;
	b=Q2oIZpzDGRIO+YubMN6GzBS4HwS0tnJZwuyzL7aM0pU1LdWwje4GYtB1GvYCeub2q
	 xw24OMn1xdqLWGIWRyIRgZzFOQbLR5ttqiSCBvxBpJ2JpLNCqoIsgAwkRyaJA0yoKv
	 ThSxTFpMvYchLvmy2lgI3AOU4nfHvqWji5WaHA/w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbgIAWLp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 1 Sep 2020 18:11:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:53260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726173AbgIAWLp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 1 Sep 2020 18:11:45 -0400
Received: from quaco.ghostprotocols.net (unknown [179.97.37.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98329206C0;
        Tue,  1 Sep 2020 22:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598998304;
        bh=/F1vhAW8eEW/niSrMCLIxso0TGb0/c4qmJMSoVaUS9s=;
        h=Date:From:To:Cc:Subject:From;
        b=0lZq6huvVQAjrDHiBBCEWVoEgywMv1dtePlot46z0Ivq4a/big8NdgkL8srvjVipD
         O4o8YywKVnQnDztHDxdSGi//v6NhxqCxuq2GhcOvk4qp2HdrFJdt6B4PQH3HlgpHhg
         9VxrrZHRd842BiFzPAFRzu7rQgFUgn7F4SkN96MA=
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id F289340D3D; Tue,  1 Sep 2020 19:11:41 -0300 (-03)
Date:   Tue, 1 Sep 2020 19:11:41 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: libtracevent: Build warning on 32-bit arches
Message-ID: <20200901221141.GB1464000@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url:  http://acmel.wordpress.com
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Tzvetomir,

	I noticed this:

  27 debian:experimental-x-mips    : Ok   mips-linux-gnu-gcc (Debian 8.3.0-19) 8.3.0
  29 debian:experimental-x-mipsel  : Ok   mipsel-linux-gnu-gcc (Debian 9.2.1-8) 9.2.1 20190909
  64 ubuntu:16.04-x-powerpc        : Ok   powerpc-linux-gnu-gcc (Ubuntu 5.4.0-6ubuntu1~16.04.9) 5.4.0 20160609
  69 ubuntu:18.04-x-arm            : Ok   arm-linux-gnueabihf-gcc (Ubuntu/Linaro 7.5.0-3ubuntu1~18.04) 7.5.0
  71 ubuntu:18.04-x-m68k           : Ok   m68k-linux-gnu-gcc (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0
  77 ubuntu:18.04-x-sh4            : Ok   sh4-linux-gnu-gcc (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0

    event-parse.c: In function 'print_arg_pointer':
    event-parse.c:5262:29: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
       trace_seq_printf(s, "%p", (void *)val);
                                 ^
The cset is:

  487ae1f4a17c197a ("tools lib traceevent: Add support for more printk format specifiers")

Best regards,

- Arnaldo
