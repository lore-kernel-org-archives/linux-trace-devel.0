Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C15C9C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Jul 2022 18:47:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236674AbiGMSrr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Jul 2022 14:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbiGMSrp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Jul 2022 14:47:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADBE92C654;
        Wed, 13 Jul 2022 11:47:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B251B81E38;
        Wed, 13 Jul 2022 18:47:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39B6DC34114;
        Wed, 13 Jul 2022 18:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657738062;
        bh=4rDfaPKROHhhVXEVjoVbRQkOiciAvRHPA1flmVehtyk=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=l/GczeGRAjW2IAxLewUEtoGNqhjYzEV07q28vyPsMG96cZOVueHmAk1dZ1SN74q0a
         Y7/dAMTNjX4tPVAMMJlzQaJKduDux2ktE90KDYIjn5fLBsMMuQwbohmKJEL1pq5ECV
         WA9eQSNY1Xm3B6qkZ7rmurDpQZ5t7JPRft4kBbamb+zQDtyfSCiEyVcwRdp578hceu
         RgqwBz9skTWvs3RALvyYsNq0xBDayp/AGLQHX1RjUtVZwpakx/8gcNUPkZUh0HJQz4
         jYf30JC62sJ3wAZcT+ywX6nXntmZJFHo+pzgx1wVxTkalaaQMKcDEwCfx6sNuPaz9a
         rXODNrdWJMy7A==
Message-ID: <d6d0220e-3464-cdb0-983d-d7677ce297da@kernel.org>
Date:   Wed, 13 Jul 2022 20:47:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH V4 13/20] rv/reactor: Add the panic reactor
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
 <67e522ab57e64eee313af508a8c70f3cce33e525.1655368610.git.bristot@kernel.org>
 <3230f073-5228-693e-f7cd-5fc4b7226a66@infradead.org>
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
In-Reply-To: <3230f073-5228-693e-f7cd-5fc4b7226a66@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 6/16/22 23:03, Randy Dunlap wrote:
>>  	  Enables the printk reactor. The printk reactor emmits a printk()
> 	                                                 emits
> 

Fixed all the cases!

-- Daniel
