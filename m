Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9AE6C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Jun 2022 16:18:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382784AbiFQQSL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 Jun 2022 12:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383231AbiFQQSK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 Jun 2022 12:18:10 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 278D52BB34;
        Fri, 17 Jun 2022 09:18:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 87B70CE2C2C;
        Fri, 17 Jun 2022 16:18:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C5FC3411B;
        Fri, 17 Jun 2022 16:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655482685;
        bh=nuz1WM5Oa3ePTXUEbxlVKyfN1W7nA0w8fVej9LOyDpU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=kDGbekmq5K+Fd7P94YdGndn3GZahGJXpFJs7zYvxDHGDB8iJjRrk0fL6l38mZnqem
         xflkTN6ajXmszOrUWxY8LtTsstEPs8AXlkaD67V+niK3tkzeoGoSENMStmHksfyiup
         Q2faP/v4j81N9mQ+WYSgpg/P6UxQHtKD3sEe53jHB8vefoyGpP1g8hYIOTygQNHrL0
         0ZFCka7ntrEKvBbUVHwUxvDH6k6iqVNtAIg6ayjgOflE8zOEQVbVWAlM7nqEBKpyAd
         LOvUjkQh9UfuXpzlSodYV5zf4rhh9k8o1bzSo/VyjeEkstmPrcXgPw6HEZKS1B+qhl
         m5uft5P5bEk+g==
Message-ID: <2abc864e-b8af-cc3f-b10d-bd450d443656@kernel.org>
Date:   Fri, 17 Jun 2022 18:17:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH V4 18/20] rv/monitor: Add safe watchdog monitor
Content-Language: en-US
To:     Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Gabriele Paoloni <gpaoloni@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Clark Williams <williams@redhat.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-trace-devel@vger.kernel.org
References: <cover.1655368610.git.bristot@kernel.org>
 <6366fdc89d65b8d9b14ccd1e42fa0d793fbe9f73.1655368610.git.bristot@kernel.org>
 <2a54bec4-5902-b22a-13f2-2237f4b10164@infradead.org>
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
In-Reply-To: <2a54bec4-5902-b22a-13f2-2237f4b10164@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 6/16/22 22:57, Randy Dunlap wrote:
> Hi--
> 
> On 6/16/22 01:45, Daniel Bristot de Oliveira wrote:
>> diff --git a/kernel/trace/rv/Kconfig b/kernel/trace/rv/Kconfig
>> index 21f03fb3101a..b14ae63e792b 100644
>> --- a/kernel/trace/rv/Kconfig
>> +++ b/kernel/trace/rv/Kconfig
>> @@ -45,6 +45,16 @@ config RV_MON_WWNR
>>  	  illustrates the usage of per-task monitor. The model is
>>  	  broken on purpose: it serves to test reactors.
>>  
>> +config RV_MON_SAFE_WTD
>> +	select DA_MON_EVENTS_IMPLICIT
>> +	bool "Safety watchdog"
>> +	help
>> +	  Enable safe_wtd, this monitor observes the interaction
>> +	  between a user-space safety monitor and a watchdog device.
>> +
>> +	  For futher information see:
>> +	    Documentation/trace/rv/safety-monitor.rst
> I'm curious about what "WTD" means.
> 
> I see lots of WDT in drivers/watchdog/Kconfig
> (where it means WatchDog Timer AFAIK).

Yep, watchdog. I will add the long description right after the first WTD appearance.

-- Daniel

> thanks.

