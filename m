Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B273FC433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Oct 2021 15:42:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 943FF60FC1
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Oct 2021 15:42:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbhJSPov (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 19 Oct 2021 11:44:51 -0400
Received: from gateway36.websitewelcome.com ([192.185.188.18]:16682 "EHLO
        gateway36.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229584AbhJSPou (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 19 Oct 2021 11:44:50 -0400
X-Greylist: delayed 709 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Oct 2021 11:44:50 EDT
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway36.websitewelcome.com (Postfix) with ESMTP id 1121540108357
        for <linux-trace-devel@vger.kernel.org>; Tue, 19 Oct 2021 10:41:33 -0500 (CDT)
Received: from gator4132.hostgator.com ([192.185.4.144])
        by cmsmtp with SMTP
        id crF7mS9Ag6dDycrF7m2bSL; Tue, 19 Oct 2021 10:41:33 -0500
X-Authority-Reason: nr=8
Received: from host-79-18-63-114.retail.telecomitalia.it ([79.18.63.114]:58582 helo=[10.0.0.35])
        by gator4132.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <bristot@kernel.org>)
        id 1mcrF5-001qRQ-L5; Tue, 19 Oct 2021 10:41:31 -0500
Message-ID: <5796a3d5-ae98-9d28-138f-981a06dab34b@kernel.org>
Date:   Tue, 19 Oct 2021 17:41:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH V3 13/19] rtla: Add Documentation
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Ingo Molnar <mingo@redhat.com>, Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Clark Williams <williams@redhat.com>,
        John Kacur <jkacur@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
References: <cover.1634574261.git.bristot@kernel.org>
 <7e205854656f41afe9a35e6390d3e3cbd724706f.1634574261.git.bristot@kernel.org>
 <877deaut3b.fsf@meer.lwn.net>
 <f0c50222-a9a8-d0e5-d705-d9d670467142@kernel.org>
 <20211019092124.6b403ca4@gandalf.local.home>
 <ecf3bfee-8a7a-e3bf-4fba-af9bc479526e@kernel.org>
 <8735oxt4ny.fsf@meer.lwn.net> <20211019113618.02bcdf8b@gandalf.local.home>
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
In-Reply-To: <20211019113618.02bcdf8b@gandalf.local.home>
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
X-Exim-ID: 1mcrF5-001qRQ-L5
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: host-79-18-63-114.retail.telecomitalia.it ([10.0.0.35]) [79.18.63.114]:58582
X-Source-Auth: kernel@bristot.me
X-Email-Count: 17
X-Source-Cap: YnJpc3RvdG1lO2JyaXN0b3RtZTtnYXRvcjQxMzIuaG9zdGdhdG9yLmNvbQ==
X-Local-Domain: no
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 10/19/21 17:36, Steven Rostedt wrote:
> On Tue, 19 Oct 2021 09:28:33 -0600
> Jonathan Corbet <corbet@lwn.net> wrote:
> 
>> My first reaction would be to make a new directory like
>> Documentation/tools and put man pages there.  That can become a new
>> "book" within the larger documentation collection.  Make sense?
> 
> Sounds good to me. Daniel?

Sounds good to me... actually, not only to me, but for all tools on tools I guess.

Should I start with Documentation/tools/rtla/${rtla_files}.rst?

-- Daniel

> -- Steve
> 

