Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E056C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 25 Oct 2021 08:08:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7668E60EBD
	for <linux-trace-devel@archiver.kernel.org>; Mon, 25 Oct 2021 08:08:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbhJYILH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 25 Oct 2021 04:11:07 -0400
Received: from gateway21.websitewelcome.com ([192.185.45.159]:48932 "EHLO
        gateway21.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230106AbhJYILG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 25 Oct 2021 04:11:06 -0400
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway21.websitewelcome.com (Postfix) with ESMTP id B685B400CD789
        for <linux-trace-devel@vger.kernel.org>; Mon, 25 Oct 2021 03:08:44 -0500 (CDT)
Received: from gator4132.hostgator.com ([192.185.4.144])
        by cmsmtp with SMTP
        id ev2CmJpC0IWzGev2CmU0aF; Mon, 25 Oct 2021 03:08:44 -0500
X-Authority-Reason: nr=8
Received: from host-79-18-63-114.retail.telecomitalia.it ([79.18.63.114]:60736 helo=[10.0.0.35])
        by gator4132.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <bristot@kernel.org>)
        id 1mev2B-0005dA-DQ; Mon, 25 Oct 2021 03:08:43 -0500
Message-ID: <7770e301-178f-725a-aa7f-b674b41ed20c@kernel.org>
Date:   Mon, 25 Oct 2021 10:08:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH V4 05/19] trace/osnoise: Allow multiple instances of the
 same tracer
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
References: <cover.1634820694.git.bristot@kernel.org>
 <6da5c06e2455e4edca4f4115199bf2bf3844798c.1634820694.git.bristot@kernel.org>
 <20211022224711.7d1cbddf@rorschach.local.home>
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
In-Reply-To: <20211022224711.7d1cbddf@rorschach.local.home>
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
X-Exim-ID: 1mev2B-0005dA-DQ
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: host-79-18-63-114.retail.telecomitalia.it ([10.0.0.35]) [79.18.63.114]:60736
X-Source-Auth: kernel@bristot.me
X-Email-Count: 2
X-Source-Cap: YnJpc3RvdG1lO2JyaXN0b3RtZTtnYXRvcjQxMzIuaG9zdGdhdG9yLmNvbQ==
X-Local-Domain: no
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 10/23/21 04:47, Steven Rostedt wrote:
> On Thu, 21 Oct 2021 14:56:43 +0200
> Daniel Bristot de Oliveira <bristot@kernel.org> wrote:
> 
>> Allow more than one instance of the same tracer. The workload will
>> start when the first trace_array (instance) is registered and will
>> stop when the last instance is unregistered.
>>
> 
> 
>> Osnoise and timerlat are still mutually exclusive because of the
>> different behavior of the osnoise: tracepoints.
> 
> I don't understand what the above means, or how it is relative to this
> commit?


osnoise and timerlat tracers share a lot of code, including the osnoise: events.

However, the osnoise: events have different behavior depending on which tracer
is enabled. So, while this patch allows the same tracer to run in multiple
instances (e.g., two instances running osnoise), it still does not allow
instances of timerlat and osnoise in parallel (e.g., one timerlat and osnoise).

Should I add the text above to the log?

It is possible to extend the current behavior to allow concurrent osnoise and
timerlat tracers to run on different CPUs. For instance, osnoise on cpu 0,1 and
timerlat on cpu 2,3. This is on my to-do list, but it is not necessary for now.

-- Daniel


> -- Steve
> 

