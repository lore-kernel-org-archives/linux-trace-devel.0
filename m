Return-Path: <SRS0=ULQB=4F=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D41BCC7619B
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 Feb 2020 08:50:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A59972064C
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 Feb 2020 08:50:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Icvy6Ahg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728531AbgBQIul (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 Feb 2020 03:50:41 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45741 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728355AbgBQIul (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 Feb 2020 03:50:41 -0500
Received: by mail-wr1-f66.google.com with SMTP id g3so18560419wrs.12
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 Feb 2020 00:50:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tg0CKAdVjDhnQJW/Ot0QYl5qMsAeSO5f1cSuf5RsJtk=;
        b=Icvy6AhgqhtSqGkDgLZIUgqyem84qaiirErivNo4hudHkmxiEF4h+Bl7i5CxJsk2VL
         /fiuouMWtzZ3xDAxrXRSRCYz8T7lswy321xCL7RN03vzjnAuXLb4SMgX6dGow6PNAVJq
         q5bisYmZ94Sd22HjmSxrg6f91Tr5gyLXNXwr1xekdlcYBtOFMGflzfGfbYDfBSRUU/fM
         bd6XolOz2joLIp7Km+vlqEBBmc8PQ5FWsgTPVceHlXm4TBhAch9uRqrK32mnaBkcY5pt
         ikw8n0BJUch46mVm/KJOE4ay97sBnHm4/qauFg0LBftu0mqxL+wqCpQYo0tXa6dofmY8
         6rPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tg0CKAdVjDhnQJW/Ot0QYl5qMsAeSO5f1cSuf5RsJtk=;
        b=D/Nezo47PKbuTPQ6FjlkYnOwdusXBPs9J043PQHr/Fyt5bWo18NpJgrPbV728y/aoP
         c7G+UZl1Z4j9DRXMnQHmr5BD0skr5Vd5DlGXltcsmETOyRhjdLSo1jEgx1hXHugEVLj8
         FWrDvLh30RVidIhaNQoJI+gUShucB4SZSfkJrX+3I0qdN9dbYD2f28trbBMaZzUMvVxm
         ib7ESlVKULHpr73mCE40enMcUEOD82fWf5uxv8WO7Ft9oU0N/BrThGlIA6ctLbDwTGq5
         mNL7delSVFFWaaIqAEJXpHYUk9jljkjREjJi0Cuc03y3FiUbIjmV6jBn51WH5zbUbEyb
         WTaQ==
X-Gm-Message-State: APjAAAUU0E4W5N7OYeqCHgfJS7i1pef/yO5HjBBjvjkFSGVkj/FTXwci
        H7t6rMx8JKvPMOXqHSdzov9LHsZx
X-Google-Smtp-Source: APXvYqw7puPX2iA+ufv6ctlspZT2JHTA8Q3Qkgcgm334cfPJ4YILHi9A/69MV8TedicZgc2XPize6g==
X-Received: by 2002:adf:cd92:: with SMTP id q18mr20460941wrj.261.1581929437344;
        Mon, 17 Feb 2020 00:50:37 -0800 (PST)
Received: from [10.27.112.58] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id w13sm20233884wru.38.2020.02.17.00.50.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Feb 2020 00:50:36 -0800 (PST)
Subject: Re: [PATCH] kernel-shark: Fix search path for libtracefs
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
References: <20200205070743.13836-1-tz.stoyanov@gmail.com>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <df514fe1-f068-0cf2-304d-b40fb64b999c@gmail.com>
Date:   Mon, 17 Feb 2020 10:50:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200205070743.13836-1-tz.stoyanov@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 5.02.20 г. 9:07 ч., Tzvetomir Stoyanov (VMware) wrote:
> Cmake uses wrong relative path while searching for
> development version of libtracefs: lib/trace-cmd,
> but the tracefs library is located at lib/tracefs
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>   kernel-shark/build/FindTraceCmd.cmake | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel-shark/build/FindTraceCmd.cmake b/kernel-shark/build/FindTraceCmd.cmake
> index f27fafe..c29b779 100644
> --- a/kernel-shark/build/FindTraceCmd.cmake
> +++ b/kernel-shark/build/FindTraceCmd.cmake
> @@ -43,7 +43,7 @@ find_library(TRACECMD_LIBRARY   NAMES  trace-cmd/libtracecmd.a
>                                          ${CMAKE_SOURCE_DIR}/../lib/
>                                   NO_DEFAULT_PATH)
>   
> -find_library(TRACEFS_LIBRARY    NAMES  trace-cmd/libtracefs.a
> +find_library(TRACEFS_LIBRARY    NAMES  tracefs/libtracefs.a
>                                   PATHS  $ENV{TRACE_CMD}/lib/
>                                          ${CMAKE_SOURCE_DIR}/../lib/
>                                   NO_DEFAULT_PATH)
> 

Hi Ceco,
Thanks for the fix!
Yordan

Fixes: 930ae46d9 (trace-cmd,kernel-shark: Introduce libtracefs library)
Reviewed-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
