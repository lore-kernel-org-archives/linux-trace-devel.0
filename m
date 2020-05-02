Return-Path: <SRS0=xxv2=6Q=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFE55C3A5A9
	for <linux-trace-devel@archiver.kernel.org>; Sat,  2 May 2020 18:47:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDA1820731
	for <linux-trace-devel@archiver.kernel.org>; Sat,  2 May 2020 18:47:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JtsZmCOM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728252AbgEBSrg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 2 May 2020 14:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726306AbgEBSrg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 2 May 2020 14:47:36 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 840E8C061A0C
        for <linux-trace-devel@vger.kernel.org>; Sat,  2 May 2020 11:47:34 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id b20so6054658lff.2
        for <linux-trace-devel@vger.kernel.org>; Sat, 02 May 2020 11:47:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=qMMrr7jaoc9gfFySLyajLt2kEX2xkuSbnXw1jJQwRZE=;
        b=JtsZmCOMd3CQH1IJd0bNMVCWxkoYUqt2SRnLXD1bjXh7vfXF2V6b2iGESV8CtL3z+F
         vmr0wY5UKBK4iHHTzPm5g1DZpb0YW/ReQPN0q24F26t6Gf+AqVvgruRx/ZsDBYS1WBQX
         f2ziGgRE4BUXAryiCziFdJlhO6VsN2F1qaDQmVfAeUgsMLKLV39GXLzfZWDP/0kZQaRp
         jKdgr0Ii8/4njpfbk5E04607qSz8f5YjEYJrpGAGoPPJCMbrnceXuWhmNDkPNljA5ZtS
         Ht0Phu2sHgct+Vdt3CZtvPxBBMQTriVqAcr5ze3YSFIXImrFRHCSyv9q2eETP+odGi+N
         NGAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=qMMrr7jaoc9gfFySLyajLt2kEX2xkuSbnXw1jJQwRZE=;
        b=q+ppIZTVsUbsMH6xWWqZZw3DWK2fOjdwb7vrc2cwtPzkZEHQ8K/RTufT9y/pJ8A0Ye
         aF0rDSJ7D4nJwQqapYjcX32llpMTs2/CVQVz+rH2qTDXU7VITl3qb6m4E+DWwEljzz12
         /KJ7dvILDYe/uXnDIV3K4N2xHWU8UjKUaIPRPMMSIA1/xUbTpSIjKEMvvU2czL569tfj
         y4BdRJFWTSuj2CoRfWqIdgkNmAWoZQ6Ojhib0eL23lD0rsOvHzyylTry/pvCYIas9I8U
         fCfhOTPronUrL1msvQDiBZcWngrEa9fDu6qddJv0Gowuj9fphonQF6xaLeBDpEG2PNAT
         qrkQ==
X-Gm-Message-State: AGi0PuZTTpar2VjUoy3AD7KDuWYFKFGaF/mN/VzcVdFbBYZOeJHmVTsh
        2gSPyJm3rQr8yq9fen2sW/cpHgk3tpw=
X-Google-Smtp-Source: APiQypJWTshVt8vyqci8omQNo7npFchg9YqlKqxNbO2gf+6CZMt9Ubjw/FGyO2WmSUnrcS6tLp6VTg==
X-Received: by 2002:ac2:4573:: with SMTP id k19mr6105171lfm.144.1588445251420;
        Sat, 02 May 2020 11:47:31 -0700 (PDT)
Received: from [192.168.0.104] ([84.40.73.119])
        by smtp.gmail.com with ESMTPSA id t19sm5000105lfl.53.2020.05.02.11.47.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 May 2020 11:47:30 -0700 (PDT)
From:   Yordan Karadzhov <y.karadz@gmail.com>
X-Google-Original-From: Yordan Karadzhov <y.karadz@Gmail.com>
Subject: Re: [PATCH 2/3] kernel-shark: Change the mechanism of the
 multi-threaded search
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20200330161723.29816-1-y.karadz@gmail.com>
 <20200330161723.29816-3-y.karadz@gmail.com>
 <20200424161246.4d9f22b8@gandalf.local.home>
 <69e2a749-8582-35dc-0a6d-5d08988d4a5c@gmail.com>
 <20200427151802.7a3a9be3@gandalf.local.home>
 <20200430225637.1b05d3ed@gandalf.local.home>
Message-ID: <f0947778-bfb5-4f0f-15a5-636e81f2a92d@Gmail.com>
Date:   Sat, 2 May 2020 21:47:28 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200430225637.1b05d3ed@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 1.05.20 г. 5:56 ч., Steven Rostedt wrote:
> On Mon, 27 Apr 2020 15:18:02 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
>
>>> I would say we can apply both. What do you think?
>> I'll try it out and let you know.
> Want to resend this patch with this change?

OK, Thanks!

Yordan

>
> -- Steve
>
> diff --git a/kernel-shark/src/KsModels.cpp b/kernel-shark/src/KsModels.cpp
> index ac58ca0a..51a7b79f 100644
> --- a/kernel-shark/src/KsModels.cpp
> +++ b/kernel-shark/src/KsModels.cpp
> @@ -91,7 +91,7 @@ size_t KsFilterProxyModel::_search(int column,
>   		}
>   
>   		/* Deal with the Progress bar of the seatch. */
> -		if ((index - first) > milestone) {
> +		if ((index - first) >= milestone) {
>   			milestone += pbCount;
>   			if (notify) {
>   				/*
> diff --git a/kernel-shark/src/KsTraceViewer.cpp b/kernel-shark/src/KsTraceViewer.cpp
> index 12371ad7..0e0e3d4e 100644
> --- a/kernel-shark/src/KsTraceViewer.cpp
> +++ b/kernel-shark/src/KsTraceViewer.cpp
> @@ -788,7 +788,7 @@ void KsTraceViewer::_searchItemsMT()
>   					  false)); // notify = false
>   
>   	while (_searchFSM.getState() == search_state_t::InProgress_s &&
> -	       _proxyModel.searchProgress() < KS_PROGRESS_BAR_MAX - nThreads) {
> +	       _proxyModel.searchProgress() < KS_PROGRESS_BAR_MAX - nThreads - 1) {
>   		std::unique_lock<std::mutex> lk(_proxyModel._mutex);
>   		_proxyModel._pbCond.wait(lk);
>   		_searchFSM.setProgress(_proxyModel.searchProgress());

