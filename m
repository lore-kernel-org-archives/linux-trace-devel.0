Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFB09C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Oct 2021 08:23:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C561460E8B
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Oct 2021 08:23:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233975AbhJZIZx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 26 Oct 2021 04:25:53 -0400
Received: from gateway22.websitewelcome.com ([192.185.46.229]:43364 "EHLO
        gateway22.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233763AbhJZIZw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 26 Oct 2021 04:25:52 -0400
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway22.websitewelcome.com (Postfix) with ESMTP id E4E8810F4C
        for <linux-trace-devel@vger.kernel.org>; Tue, 26 Oct 2021 03:23:27 -0500 (CDT)
Received: from gator4132.hostgator.com ([192.185.4.144])
        by cmsmtp with SMTP
        id fHjzmvt8eIWzGfHjzm5pgl; Tue, 26 Oct 2021 03:23:27 -0500
X-Authority-Reason: nr=8
Received: from host-79-18-63-114.retail.telecomitalia.it ([79.18.63.114]:60752 helo=[10.0.0.35])
        by gator4132.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <bristot@kernel.org>)
        id 1mfHjy-002lOp-DV; Tue, 26 Oct 2021 03:23:26 -0500
Message-ID: <10c64d17-9db7-eb56-537e-e032b7a14e8e@kernel.org>
Date:   Tue, 26 Oct 2021 10:23:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH V5 04/20] trace/osnoise: Use start/stop_per_cpu_kthreads()
 on osnoise_cpus_write()
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Ingo Molnar <mingo@redhat.com>, Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Clark Williams <williams@redhat.com>,
        John Kacur <jkacur@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1635181938.git.bristot@kernel.org>
 <2b4ea45b1802844cffd98b6a208b22bc4664c795.1635181938.git.bristot@kernel.org>
 <20211025210843.36fe2829@rorschach.local.home>
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
In-Reply-To: <20211025210843.36fe2829@rorschach.local.home>
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
X-Exim-ID: 1mfHjy-002lOp-DV
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: host-79-18-63-114.retail.telecomitalia.it ([10.0.0.35]) [79.18.63.114]:60752
X-Source-Auth: kernel@bristot.me
X-Email-Count: 2
X-Source-Cap: YnJpc3RvdG1lO2JyaXN0b3RtZTtnYXRvcjQxMzIuaG9zdGdhdG9yLmNvbQ==
X-Local-Domain: no
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 10/26/21 03:08, Steven Rostedt wrote:
> On Mon, 25 Oct 2021 19:40:29 +0200
> Daniel Bristot de Oliveira <bristot@kernel.org> wrote:
> 
>> When writing a new CPU mask via osnoise/cpus, if the tracer is running,
>> the workload is restarted to follow the new cpumask. The restart is
>> currently done using osnoise_workload_start/stop(), which disables the
>> workload *and* the instrumentation. However, disabling the
>> instrumentation is not necessary.
>>
>> Calling start/stop_per_cpu_kthreads() is enough to apply the new
>> osnoise/cpus config.
>>
>> No functional change.
> 
> I nuked the "No functional change.". You can't have the changes of the
> above and say there wasn't functional changes, as the first paragraph
> explains the functional changes.

ack, /me takes note.

-- Daniel
> 
> -- Steve
> 

