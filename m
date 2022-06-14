Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC25BCCA47A
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Jun 2022 12:45:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240381AbiFNMpJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Jun 2022 08:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235786AbiFNMpE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Jun 2022 08:45:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66DFA1182F
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Jun 2022 05:45:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2068EB81871
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Jun 2022 12:44:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CAB1C3411B;
        Tue, 14 Jun 2022 12:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655210697;
        bh=J9jeaAxFh5xMNBfU+VEWczZsn32F5ZOPVZj5SwqRsgU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=g0f40S3iVhMV0IkGT3BJKJRXqk2/Fd59ddtWasK6AOEzwkNeRTKBmlGkBECIQT9y6
         omjfpfbENX5RJF7sBqtR6jJMjYwIfyhMcolsHFOCqMOaqvygsJbKhq2e0pyeuReGJh
         TvEL9xcit2V7IGukUr+dzIh35dfSSm3huLynI/aHPmR2qYzf3LWn5YjOuLuS4v9Lgq
         I9mKpPaV+QTTQqSfX/f5008jGAPESHtjEuqH/h2Sj30Ylqbz/oOn0iYHTfW2zXIg5C
         9N3klzGniYbbpB/9MoGyo03ALyQffHDPdQ4G5w05jjZlLK/xocFRwDtMDz2CDDkM9N
         Uztm1++f0ziXg==
Message-ID: <e9a891e6-586d-46a6-d623-6d25575f62c8@kernel.org>
Date:   Tue, 14 Jun 2022 14:44:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] rtla/utils: Fix the potential memory allocation failure
Content-Language: en-US
To:     jianchunfu <jianchunfu@cmss.chinamobile.com>
Cc:     linux-trace-devel@vger.kernel.org, rostedt@goodmis.org
References: <20220614093800.8743-1-jianchunfu@cmss.chinamobile.com>
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
In-Reply-To: <20220614093800.8743-1-jianchunfu@cmss.chinamobile.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi

On 6/14/22 11:38, jianchunfu wrote:
> Add memory allocating check of mon_cpus before used in utils.
> 
Yeah, you found a problem, thanks for you patch! But it needs improvement.

Please, add the Fixes: tag.
Please Cc: linux-kernel

> Signed-off-by: jianchunfu <jianchunfu@cmss.chinamobile.com>
> ---
>  tools/tracing/rtla/src/utils.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/tools/tracing/rtla/src/utils.c b/tools/tracing/rtla/src/utils.c
> index ffaf8ec84..2a86440b3 100644
> --- a/tools/tracing/rtla/src/utils.c
> +++ b/tools/tracing/rtla/src/utils.c
> @@ -106,6 +106,10 @@ int parse_cpu_list(char *cpu_list, char **monitored_cpus)
>  	nr_cpus = sysconf(_SC_NPROCESSORS_CONF);
>  
>  	mon_cpus = malloc(nr_cpus * sizeof(char));
> +	if (!mon_cpus) {
> +		perror("Failed to allocate memory");
> +		return -errno;
> +	}
>  	memset(mon_cpus, 0, (nr_cpus * sizeof(char)));

Your patch is fixing the problem, but it can be improved by:
	- using calloc (as in other .c)
	- removing the memset
	- instead of returning, goto err;

Do you mind sending a v2?

-- Daniel
