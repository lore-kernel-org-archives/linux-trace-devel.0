Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C630C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Nov 2021 14:01:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232438AbhKYOEs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Nov 2021 09:04:48 -0500
Received: from gateway30.websitewelcome.com ([192.185.151.58]:14774 "EHLO
        gateway30.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232728AbhKYOCq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Nov 2021 09:02:46 -0500
X-Greylist: delayed 1199 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Nov 2021 09:02:46 EST
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway30.websitewelcome.com (Postfix) with ESMTP id 0EB0C11ABE
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Nov 2021 07:39:25 -0600 (CST)
Received: from gator4132.hostgator.com ([192.185.4.144])
        by cmsmtp with SMTP
        id qEwFmHmxrL3b1qEwGmZ4C1; Thu, 25 Nov 2021 07:37:24 -0600
X-Authority-Reason: nr=8
Received: from host-79-34-250-122.business.telecomitalia.it ([79.34.250.122]:43158 helo=[10.0.0.34])
        by gator4132.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <bristot@kernel.org>)
        id 1mqEwE-0030nq-9x; Thu, 25 Nov 2021 07:37:22 -0600
Message-ID: <d3433041-33e3-f013-7631-b162d6f35af6@kernel.org>
Date:   Thu, 25 Nov 2021 14:37:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH V7 01/14] rtla: Real-Time Linux Analysis tool
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Tao Zhou <tao.zhou@linux.dev>, Ingo Molnar <mingo@redhat.com>,
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
References: <cover.1635535309.git.bristot@kernel.org>
 <7c776914f3316cf6b5c21ec01b1e4eae497bb510.1635535309.git.bristot@kernel.org>
 <20211124162814.352ad8fd@gandalf.local.home>
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
In-Reply-To: <20211124162814.352ad8fd@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4132.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.org
X-BWhitelist: no
X-Source-IP: 79.34.250.122
X-Source-L: No
X-Exim-ID: 1mqEwE-0030nq-9x
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: host-79-34-250-122.business.telecomitalia.it ([10.0.0.34]) [79.34.250.122]:43158
X-Source-Auth: kernel@bristot.me
X-Email-Count: 2
X-Source-Cap: YnJpc3RvdG1lO2JyaXN0b3RtZTtnYXRvcjQxMzIuaG9zdGdhdG9yLmNvbQ==
X-Local-Domain: no
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 11/24/21 22:28, Steven Rostedt wrote:
> On Fri, 29 Oct 2021 21:26:04 +0200
> Daniel Bristot de Oliveira <bristot@kernel.org> wrote:
> 
>> The rtla is a meta-tool that includes a set of commands that aims
>> to analyze the real-time properties of Linux. But instead of testing
>> Linux as a black box, rtla leverages kernel tracing capabilities to
>> provide precise information about the properties and root causes of
>> unexpected results.
>>
>> rtla --help works and provide information about the available options.
>>
>> This is just the "main" and the Makefile, no function yet.
>>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: Tom Zanussi <zanussi@kernel.org>
>> Cc: Masami Hiramatsu <mhiramat@kernel.org>
>> Cc: Juri Lelli <juri.lelli@redhat.com>
>> Cc: Clark Williams <williams@redhat.com>
>> Cc: John Kacur <jkacur@redhat.com>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>> Cc: Daniel Bristot de Oliveira <bristot@kernel.org>
>> Cc: linux-rt-users@vger.kernel.org
>> Cc: linux-trace-devel@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
>> ---
>>  tools/tracing/rtla/Makefile   | 76 +++++++++++++++++++++++++++++++++++
>>  tools/tracing/rtla/src/rtla.c | 72 +++++++++++++++++++++++++++++++++
>>  2 files changed, 148 insertions(+)
>>  create mode 100644 tools/tracing/rtla/Makefile
>>  create mode 100644 tools/tracing/rtla/src/rtla.c
>>
>> diff --git a/tools/tracing/rtla/Makefile b/tools/tracing/rtla/Makefile
>> new file mode 100644
>> index 000000000000..33f154f86519
>> --- /dev/null
>> +++ b/tools/tracing/rtla/Makefile
>> @@ -0,0 +1,76 @@
>> +NAME	:=	rtla
>> +VERSION	:=	0.3
>> +
>> +# From libtracefs:
>> +# Makefiles suck: This macro sets a default value of $(2) for the
>> +# variable named by $(1), unless the variable has been set by
>> +# environment or command line. This is necessary for CC and AR
>> +# because make sets default values, so the simpler ?= approach
>> +# won't work as expected.
>> +define allow-override
>> +  $(if $(or $(findstring environment,$(origin $(1))),\
>> +            $(findstring command line,$(origin $(1)))),,\
>> +    $(eval $(1) = $(2)))
>> +endef
>> +
>> +# Allow setting CC and AR, or setting CROSS_COMPILE as a prefix.
>> +$(call allow-override,CC,$(CROSS_COMPILE)gcc)
>> +$(call allow-override,AR,$(CROSS_COMPILE)ar)
>> +$(call allow-override,STRIP,$(CROSS_COMPILE)strip)
>> +$(call allow-override,PKG_CONFIG,pkg-config)
>> +$(call allow-override,LD_SO_CONF_PATH,/etc/ld.so.conf.d/)
>> +$(call allow-override,LDCONFIG,ldconfig)
>> +
>> +INSTALL	=	install
>> +FOPTS	:=	-flto=auto -ffat-lto-objects -fexceptions -fstack-protector-strong \
>> +		-fasynchronous-unwind-tables -fstack-clash-protection
>> +WOPTS	:= 	-Wall -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -Wp,-D_GLIBCXX_ASSERTIONS -Wno-maybe-uninitialized
>> +
>> +TRACEFS_HEADERS	:= $$($(PKG_CONFIG) --cflags libtracefs)
>> +
>> +CFLAGS	:=	-O -g -DVERSION=\"$(VERSION)\" $(FOPTS) $(MOPTS) $(WOPTS) $(TRACEFS_HEADERS)
>> +LDFLAGS	:=	-ggdb
>> +LIBS	:=	-ltracefs -ltraceevent -lprocps
> 
> For the -ltracefs and -ltracevent, you could use:
> 
>    $$($PKG_CONFIG) --libs libtracefs)
> 
> which would be more robust.

Will use!

-- Daniel

> -- Steve
> 

