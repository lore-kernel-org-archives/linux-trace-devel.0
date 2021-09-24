Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24E1BC433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 24 Sep 2021 16:53:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1D0061261
	for <linux-trace-devel@archiver.kernel.org>; Fri, 24 Sep 2021 16:53:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244770AbhIXQy4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 24 Sep 2021 12:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231635AbhIXQy4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 24 Sep 2021 12:54:56 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF3FDC061571
        for <linux-trace-devel@vger.kernel.org>; Fri, 24 Sep 2021 09:53:22 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id y12so2308981edo.9
        for <linux-trace-devel@vger.kernel.org>; Fri, 24 Sep 2021 09:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6m0wpxnBT1vcTXxHivuhJ2kSgeK4sDY8cSH0hqS2fIU=;
        b=drCdKJ2TQ3pmvBV2bFGhiktp/jPp0EEvYayWcrr3m6IkvrN2oOBANJ6MnVE+87Lrdp
         qz4Unp3Bewn+bEbkCmCwPNw+ensVwavwzy8aruVWO7Y8ROseXS9XLfO0sLTm5U+Z46aT
         uo4WTgXpAbylf94l2EtI4eT9ZvIb4p23GW8S+CG+//affvQcOldEXhjEfUADu54h3qhT
         /yjRihRq09WJ94nhPZZegmEaU7wapbW6h0xlnQ0oxleOiyxXQEvI6F8y1VDBb1G0/4OV
         gvz3plwE4n+XQnA/XS/yYvzqIFsz9mftI8c3g0c4T7S1qWkYDmH4ePOGVzVdFGSSB2Jy
         VLBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6m0wpxnBT1vcTXxHivuhJ2kSgeK4sDY8cSH0hqS2fIU=;
        b=zzN90Rpf/dwFpahqCr1Qb7G4JFEOrEXHUPBRRe4aoufR9+PYdA4Csh4NAyzeOHz1Vu
         9WQVAfjRqsQht5nKfk2ZkQQkwv5u6n2ogULbik1u9CbrPEzGLtI7b65EjUke0DTru0Ov
         DWWvTaZmxYIPLbOKvdA8tk5PDT2tkoP6ROb+yuwKCiHh6yrmYaxskAojXj3al8EQetSG
         SKn5tMvBjt+kXhKPChIrz2vNRrL1kvOHrqh3L+oI/D48KAZS/l2nfwb123QiGFie6opX
         OlkNQtMYTHQW7WoaeVHTpL4lkCxzshRAdt0jowp1NjCSnEOmJgm+J8MgiIyCnoXN29RB
         Iu5A==
X-Gm-Message-State: AOAM530t5i88NFkWwE89VTo91EIrBx1Uv2Lqurf7HyVpNetN9ZEh5W8f
        Y70zHMmtz839ymNtarRVgHBiBdq19RQ=
X-Google-Smtp-Source: ABdhPJwZGzlnDE1dg/GTLU9+2LnR2bJBIo908CZ+UIIVwVGx0jL8dIc9vrkZTvtBu82qztYVaTOTfQ==
X-Received: by 2002:a17:906:dbe3:: with SMTP id yd3mr12160471ejb.90.1632502401135;
        Fri, 24 Sep 2021 09:53:21 -0700 (PDT)
Received: from [192.168.0.108] ([84.40.93.30])
        by smtp.gmail.com with ESMTPSA id n10sm5331257ejk.86.2021.09.24.09.53.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 09:53:20 -0700 (PDT)
Subject: Re: [PATCH v2 1/4] libtracefs: Add new constructors for histograms
To:     Steven Rostedt <rostedt@goodmis.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20210924095702.151826-1-y.karadz@gmail.com>
 <20210924095702.151826-2-y.karadz@gmail.com>
 <CAPpZLN7daWb2g_45CG3NzfKrEvK8NHNE+6k1NayYOL3u2b_EDw@mail.gmail.com>
 <20210924115434.1b2c398e@gandalf.local.home>
From:   Yordan Karadzhov <y.karadz@gmail.com>
Message-ID: <7c407fb1-c0e1-3c0b-46f9-9ecc40180611@gmail.com>
Date:   Fri, 24 Sep 2021 19:53:19 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210924115434.1b2c398e@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 24.09.21 г. 18:54, Steven Rostedt wrote:
> On Fri, 24 Sep 2021 18:51:38 +0300
> Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:
> 
>>>   struct tracefs_hist *
>>>   tracefs_hist_alloc(struct tep_handle *tep,
>>
>> For consistency with the newly added "alloc" APIs, this should be
>> renamed. The dimensions of the histogram are part of the name, this
>> one is for N dimensions:
>>    tracefs_hist_alloc_1d()
>>    tracefs_hist_alloc_2d()
>>    tracefs_hist_alloc_nd()
>> or something like that.
> 
> I rather not have the _nd().
> 
>   tracefs_hist_alloc_1d()
>   tracefs_hist_alloc_2d() are more just helper handlers for specific cases.
> 
>   tracefs_hist_alloc() should be the "main" function, and hence doesn't need
> any extra annotation.
> 

My idea was the same.

Thanks!
Yordan


> -- Steve
> 
