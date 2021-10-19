Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2022BC433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Oct 2021 08:30:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0C3D61264
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Oct 2021 08:30:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbhJSIcp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 19 Oct 2021 04:32:45 -0400
Received: from gateway22.websitewelcome.com ([192.185.46.229]:12589 "EHLO
        gateway22.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231758AbhJSIcp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 19 Oct 2021 04:32:45 -0400
X-Greylist: delayed 1428 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Oct 2021 04:32:45 EDT
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway22.websitewelcome.com (Postfix) with ESMTP id E868D17854
        for <linux-trace-devel@vger.kernel.org>; Tue, 19 Oct 2021 03:06:41 -0500 (CDT)
Received: from gator4132.hostgator.com ([192.185.4.144])
        by cmsmtp with SMTP
        id ck8vmELmg6dDyck8vmpJPO; Tue, 19 Oct 2021 03:06:41 -0500
X-Authority-Reason: nr=8
Received: from host-79-18-63-114.retail.telecomitalia.it ([79.18.63.114]:58572 helo=[10.0.0.35])
        by gator4132.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <bristot@kernel.org>)
        id 1mck8u-000jRJ-HQ; Tue, 19 Oct 2021 03:06:40 -0500
Message-ID: <b093fc67-a251-fad3-e6f6-19c5d85253dc@kernel.org>
Date:   Tue, 19 Oct 2021 10:06:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH V3 06/19] rtla: Real-Time Linux Analysis tool
Content-Language: en-US
To:     "Ahmed S. Darwish" <a.darwish@linutronix.de>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Clark Williams <williams@redhat.com>,
        John Kacur <jkacur@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1634574261.git.bristot@kernel.org>
 <65fbb9b508a2c1803bacfe255c1d568eb8f4ba4f.1634574261.git.bristot@kernel.org>
 <YW3LUhMOVWTvQlKh@lx-t490>
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
In-Reply-To: <YW3LUhMOVWTvQlKh@lx-t490>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4132.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.org
X-BWhitelist: no
X-Source-IP: 79.18.63.114
X-Source-L: No
X-Exim-ID: 1mck8u-000jRJ-HQ
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: host-79-18-63-114.retail.telecomitalia.it ([10.0.0.35]) [79.18.63.114]:58572
X-Source-Auth: kernel@bristot.me
X-Email-Count: 2
X-Source-Cap: YnJpc3RvdG1lO2JyaXN0b3RtZTtnYXRvcjQxMzIuaG9zdGdhdG9yLmNvbQ==
X-Local-Domain: no
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 10/18/21 21:30, Ahmed S. Darwish wrote:
> On Mon, Oct 18, 2021, Daniel Bristot de Oliveira wrote:
>> --- /dev/null
>> +++ b/tools/tracing/rtla/Makefile
>> @@ -0,0 +1,59 @@
>> +CC	:=	gcc
> 
> Some $(CROSS_COMPILE) for the poor souls who will integrate this into
> embedded distributions?
> 
>> +
>> +TRACEFS_HEADERS		:= $$(pkg-config --cflags libtracefs)
>> +
> 
> ditto. This uses the host's pkg-config unconditionally.

mind trying this (on top of the current one)?

Thanks!

diff --git a/tools/tracing/rtla/Makefile b/tools/tracing/rtla/Makefile
index 9a914391e507..8c2b7f8c7f20 100644
--- a/tools/tracing/rtla/Makefile
+++ b/tools/tracing/rtla/Makefile
@@ -1,14 +1,30 @@
 NAME	:=	rtla
 VERSION	:=	0.1
 
+# Makefiles suck: This macro sets a default value of $(2) for the
+# variable named by $(1), unless the variable has been set by
+# environment or command line. This is necessary for CC and AR
+# because make sets default values, so the simpler ?= approach
+# won't work as expected.
+define allow-override
+  $(if $(or $(findstring environment,$(origin $(1))),\
+            $(findstring command line,$(origin $(1)))),,\
+    $(eval $(1) = $(2)))
+endef
+
+# Allow setting CC and AR, or setting CROSS_COMPILE as a prefix.
+$(call allow-override,CC,$(CROSS_COMPILE)gcc)
+$(call allow-override,AR,$(CROSS_COMPILE)ar)
+$(call allow-override,PKG_CONFIG,pkg-config)
+$(call allow-override,LD_SO_CONF_PATH,/etc/ld.so.conf.d/)
+$(call allow-override,LDCONFIG,ldconfig)
+
 INSTALL	=	install
-CC	:=	gcc
 FOPTS	:=	-flto=auto -ffat-lto-objects -fexceptions -fstack-protector-strong \
-		-fasynchronous-unwind-tables -fstack-clash-protection -fcf-protection
-MOPTS	:=	-m64 -mtune=generic
+		-fasynchronous-unwind-tables -fstack-clash-protection
 WOPTS	:= 	-Wall -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -Wp,-D_GLIBCXX_ASSERTIONS -Wno-maybe-uninitialized
 
-TRACEFS_HEADERS		:= $$(pkg-config --cflags libtracefs)
+TRACEFS_HEADERS	:= $$($(PKG_CONFIG) --cflags libtracefs)
 
 CFLAGS	:=	-O -g -DVERSION=\"$(VERSION)\" $(FOPTS) $(MOPTS) $(WOPTS) $(TRACEFS_HEADERS)
 LDFLAGS	:=	-ggdb

