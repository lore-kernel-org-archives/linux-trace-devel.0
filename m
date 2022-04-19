Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AF13C433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Apr 2022 16:23:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354594AbiDSQ0Q (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 19 Apr 2022 12:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352524AbiDSQ0P (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 19 Apr 2022 12:26:15 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19D293A5F5
        for <linux-trace-devel@vger.kernel.org>; Tue, 19 Apr 2022 09:23:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EC238CE1A94
        for <linux-trace-devel@vger.kernel.org>; Tue, 19 Apr 2022 16:23:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A61CC385A5;
        Tue, 19 Apr 2022 16:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650385409;
        bh=CjE/eIjApn/q3fuQy40MSlT/6v8fNGzjjvZG253OMAA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=YJ4EG2i4JoDocEaxUWz+4X3hao+YEcbeflcrXClKLJC2LR+CH6kexuAibFLjkWPfl
         ynZnIeUcC5cEcPRuka+fT+V4AiY/v5Bqu69rlg0xKSGbEPJNRM6dLEvxgJNk3FZ4t0
         +Y/KwfCjWsSOksMfP60N5Y+ck6aT0/l0uNHVOGVCXU2CPn+wURwUjyHBHfuT3Wj7jq
         3pmaY3VH/GawBmEEFt1R9aMLx5oH/hZWY+3c1lehQSYK4hqPT1wQd8qY7CagcTPvt5
         VhUhFEC1inQIRDW14g3BK/ZcTnVWExPmncxT/5fg8m3NS9R/Uq6A18hMNS7dbNKsuJ
         vjgI2JE5vbWew==
Message-ID: <d63d91c6-a466-0ca1-9d0d-76ad37f9eff9@kernel.org>
Date:   Tue, 19 Apr 2022 18:23:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 0/3] rtla: v5.18-rc2 Fixes
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <cover.1650029027.git.bristot@kernel.org>
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
In-Reply-To: <cover.1650029027.git.bristot@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Steven,

Please ignore this email thread. For some reason I do not know, red hat's smtp
is converting data to base64...

On 4/15/22 15:36, Daniel Bristot de Oliveira wrote:
> Steven,
> 
> Here are some fixes for rtla.
> 
> I do not include "rtla/Makefile: Properly handle dependencies"
> because I will make two changes to it:
>         -  I need to check rst2man only in the make install phase
>         -  I will remove procps-devel dependency on another patch
> 
> I will send a v2 of the "Properly handle dependencies" and the removal
> of procps-devel dependencies next week. But these ones are already ready.



> John Kacur (2):
>   rtla: Don't overwrite existing directory mode
>   rtla: Minor grammar fix for rtla README
> 
> Wan Jiabing (1):
>   rtla: Avoid record NULL pointer dereference
> 
>  tools/tracing/rtla/Makefile            |  3 ++-
>  tools/tracing/rtla/README.txt          | 12 +++++-------
>  tools/tracing/rtla/src/osnoise_hist.c  |  5 +++--
>  tools/tracing/rtla/src/osnoise_top.c   |  9 +++++----
>  tools/tracing/rtla/src/timerlat_hist.c | 11 ++++++-----
>  tools/tracing/rtla/src/timerlat_top.c  | 11 ++++++-----
>  6 files changed, 27 insertions(+), 24 deletions(-)
> 

