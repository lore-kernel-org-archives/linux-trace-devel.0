Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 500FAC4332F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Nov 2022 14:13:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233410AbiKVONc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Nov 2022 09:13:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232572AbiKVONb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Nov 2022 09:13:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32EC12D1F7;
        Tue, 22 Nov 2022 06:13:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF35BB81B3B;
        Tue, 22 Nov 2022 14:13:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C04C433B5;
        Tue, 22 Nov 2022 14:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669126407;
        bh=PE8BKHeyWsC6Kr0bzulf2KyH7RYyiK9oWUuaPxemAyg=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=I4LuZMiXg5OxeS60v5UD3vAfOMPDQ9XIHfZvOG2dx2g5EEMfpgvI3e9AWcaOBtunj
         Oog3EYvmJQ1ax3DBPOmEMXZ5tNUGn2nmG7hpoQBIu8FdwpCUj6dLPFD7MYnja1CGtK
         h2WBE6GYUxWG7chEFy4pPqvVZUGXsOwBsr7MgLu2/s4V6Hnvie1RkQGCKOCCVynD1F
         RfKsnKwLE10zt0kW/jKC5tnk2b/CspV2EfEwdQwgsIEA2QrzKvrgN0CCKxSjWGhAMl
         w6VY76DxqK30qDuJsmXCJ0WuhiJBGBvuy7xagxEfszovEz6ddDVaXoiEU61VTLlZdD
         GkpwJv/YiHA+A==
Message-ID: <7febf4f5-88d9-7902-e231-af2b6d0d6df0@kernel.org>
Date:   Tue, 22 Nov 2022 15:13:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH] rv/monitors: Move monitor structure in rodata
Content-Language: en-US
To:     Alessandro Carminati <acarmina@redhat.com>,
        linux-trace-devel@vger.kernel.org
Cc:     alessandro.carminati@gmail.com, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org
References: <20221118162033.66389-1-acarmina@redhat.com>
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
In-Reply-To: <20221118162033.66389-1-acarmina@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 11/18/22 17:20, Alessandro Carminati wrote:
> It makes sense to move the important monitor structure into rodata to
> prevent accidental structure modification.
> 
> Signed-off-by: Alessandro Carminati <acarmina@redhat.com>
> ---
>  kernel/trace/rv/monitors/wip/wip.h   | 2 +-
>  kernel/trace/rv/monitors/wwnr/wwnr.h | 2 +-
>  tools/verification/dot2/dot2c.py     | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/trace/rv/monitors/wip/wip.h b/kernel/trace/rv/monitors/wip/wip.h
> index dacc37b62a2c..9c0cd0ad5cd7 100644
> --- a/kernel/trace/rv/monitors/wip/wip.h
> +++ b/kernel/trace/rv/monitors/wip/wip.h
> @@ -27,7 +27,7 @@ struct automaton_wip {
>  	bool final_states[state_max_wip];
>  };
>  
> -static struct automaton_wip automaton_wip = {
> +const static struct automaton_wip automaton_wip = {
>  	.state_names = {
>  		"preemptive",
>  		"non_preemptive"
> diff --git a/kernel/trace/rv/monitors/wwnr/wwnr.h b/kernel/trace/rv/monitors/wwnr/wwnr.h

checkpatch says:

WARNING: Move const after static - use 'static const struct automaton_wip '
#32: FILE: kernel/trace/rv/monitors/wip/wip.h:30:
+const static struct automaton_wip automaton_wip = {

WARNING: Move const after static - use 'static const struct automaton_wwnr '
#45: FILE: kernel/trace/rv/monitors/wwnr/wwnr.h:30:
+const static struct automaton_wwnr automaton_wwnr = {

and this is also true for the dot2c part.

Do you mind fixing that in a v2?

-- Daniel
