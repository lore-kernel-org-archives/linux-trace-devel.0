Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A392C4332F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Oct 2021 19:45:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CAEC60F9D
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Oct 2021 19:45:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231572AbhJZTsS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 26 Oct 2021 15:48:18 -0400
Received: from gateway36.websitewelcome.com ([192.185.188.18]:23703 "EHLO
        gateway36.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237162AbhJZTsR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 26 Oct 2021 15:48:17 -0400
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway36.websitewelcome.com (Postfix) with ESMTP id E38BB4011533F
        for <linux-trace-devel@vger.kernel.org>; Tue, 26 Oct 2021 14:45:50 -0500 (CDT)
Received: from gator4132.hostgator.com ([192.185.4.144])
        by cmsmtp with SMTP
        id fSOMmMxpfG0jLfSOMmSECx; Tue, 26 Oct 2021 14:45:50 -0500
X-Authority-Reason: nr=8
Received: from host-79-18-63-114.retail.telecomitalia.it ([79.18.63.114]:60830 helo=[10.0.0.35])
        by gator4132.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <bristot@kernel.org>)
        id 1mfSOL-001w8I-1k; Tue, 26 Oct 2021 14:45:49 -0500
Message-ID: <435460f4-7e69-dc39-109b-a6a777da69d7@kernel.org>
Date:   Tue, 26 Oct 2021 21:45:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH V5 08/20] rtla: Helper functions for rtla
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>, Tao Zhou <tao.zhou@linux.dev>
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
 <bc01018cef80ddb95fd0ccf1ec72963be7e4fc19.1635181938.git.bristot@kernel.org>
 <YXgrLIiK8pwOVsBe@geo.homenetwork>
 <20211026122614.017844da@gandalf.local.home>
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
In-Reply-To: <20211026122614.017844da@gandalf.local.home>
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
X-Exim-ID: 1mfSOL-001w8I-1k
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: host-79-18-63-114.retail.telecomitalia.it ([10.0.0.35]) [79.18.63.114]:60830
X-Source-Auth: kernel@bristot.me
X-Email-Count: 16
X-Source-Cap: YnJpc3RvdG1lO2JyaXN0b3RtZTtnYXRvcjQxMzIuaG9zdGdhdG9yLmNvbQ==
X-Local-Domain: no
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 10/26/21 18:26, Steven Rostedt wrote:
> On Wed, 27 Oct 2021 00:22:04 +0800
> Tao Zhou <tao.zhou@linux.dev> wrote:
> 
>>> +	do {
>>> +		retval = read(in_fd, buffer, sizeof(buffer));
>>> +		if (read <= 0)  
>> check "retval" not read. Like:
>>
>>   if (retval <= 0)
> OUCH! Good check.
> 
> Daniel, did that not produce any warnings??

OUCH OUCH!

No warnings, no nothing.

The code actually "works" because errors are not common and the next if stops
the loop.

-- Daniel

> -- Steve
> 
> 

