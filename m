Return-Path: <SRS0=vGr1=5W=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1B1AC2BA80
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Apr 2020 13:24:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 946C620801
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Apr 2020 13:24:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iWdiyaK1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728448AbgDFNYq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 6 Apr 2020 09:24:46 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:40146 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728018AbgDFNYq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 6 Apr 2020 09:24:46 -0400
Received: by mail-lj1-f196.google.com with SMTP id 19so14616783ljj.7
        for <linux-trace-devel@vger.kernel.org>; Mon, 06 Apr 2020 06:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IceQTI+hVNnPA+MrSFiu5NB8nX/p4u157U+WOscgHBw=;
        b=iWdiyaK1tJIJ/PSBw3BCeG/R6HIO7bsa39D6OuDh+kV5if7bzz5C6V3EzS32u96Qfw
         N1B/X6dYGRPokO3dkgRAn3rXir2FnQ+iB1fHFbSoiocYhYvYrYTVPmDXjRf2S4VtPtbH
         9MKpHgb/b4yMpr4d6UR5xdSWhYS4bTTkHORZibgeP65fKWj2sxFHVxCWUwa7ZMbio4wI
         4OZuCy5N5djPDK4y6xOA62T+ktqKBsP3/cOT6dxfhoKcS9+KTb1x0f/wDjigm/ymZKek
         mKd22vCL1x1WVufRno0etAkS2jlxABOByd0MikUuMs+zJ2jkptbcO97YXjbjEVi8q6AN
         vPrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IceQTI+hVNnPA+MrSFiu5NB8nX/p4u157U+WOscgHBw=;
        b=MS6IVRXwIdZGV1p2yC78dD2ZiLSKRTQWViRbQ9hobMVpJWgl3J4oApAVH8btndlH7K
         OcMiheARw7EKH9drEpm9NcsRS+/u6QVUvXAoditVKvJd4xTbIfAavSp8ee1eTE64+Mwu
         1XOJC0+j0FqViiUYIzjqsRhBiPtYi9Vb+E9xRS8TRYw1F/elTq6cmSa+LOAwvNhXJhV6
         NdafsRW81/cl/N09bR+dwTjyRnDE2bpHSH7nUZo9tmew008j7SteEolXerAETzLZwi2l
         k4uCKnk+IUWkuuMZrNdY0bkXPFi9kROUF8fUmNBpmFf7BNaOp6ma5+BTlKWsqeuMyz0S
         y6EQ==
X-Gm-Message-State: AGi0Pua8N3DF7rXp5twN0XQ/OCMf6SYKqfXmv2YE0svmpqHHS4CcE06t
        pLef2yaKf1UTtteR355uOq7xfNwX
X-Google-Smtp-Source: APiQypJqvuy2bIyguh+UgemMheKb7K21+qGMmSI1+ueYUk1Uc/REykKHrSeyxgeqZYXIWznjZkfFTQ==
X-Received: by 2002:a2e:9851:: with SMTP id e17mr12282739ljj.208.1586179483443;
        Mon, 06 Apr 2020 06:24:43 -0700 (PDT)
Received: from [192.168.0.106] ([84.40.73.10])
        by smtp.gmail.com with ESMTPSA id e2sm9869603ljl.83.2020.04.06.06.24.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Apr 2020 06:24:42 -0700 (PDT)
Subject: Re: [PATCH] kernel-shark-2.alpha: Use new tracecmd API to open guest
 tracing file
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
References: <20200401164509.191494-1-tz.stoyanov@gmail.com>
 <0f53a13b-f1ff-f467-0f95-899ca404b5b0@gmail.com>
 <CAPpZLN7NLm=r3y76M1oZAVRh5S7FOCk6-ieSKOzZVtMOCJ=uxQ@mail.gmail.com>
 <5b55ebc5-d682-f934-a643-c0fe65fba003@gmail.com>
 <CAPpZLN61s-7SY_Ey8Qu7n+=v0FE6VVgxoTp-qrGgit0=Rj_0SQ@mail.gmail.com>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <3e45fc77-619f-3d3e-3f48-47d0fcf29f1d@gmail.com>
Date:   Mon, 6 Apr 2020 16:24:41 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAPpZLN61s-7SY_Ey8Qu7n+=v0FE6VVgxoTp-qrGgit0=Rj_0SQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 3.04.20 г. 20:12 ч., Tzvetomir Stoyanov wrote:
>> Maybe it has to be a bit more sophisticated. Does the "primary" stream
>> know how to recognize its "secondary" streams?
>>
> Yes, there are tracing IDs in both host and guest files. When these IDs match,
> files are from a same tracing session.
> I can add "parent_stream_id" member in "struct kshark_data_stream" and
> initialize it
> when reading the files, according to the trace IDs.

Not sure if this is the right place to put this information. I do not 
want to have "tep data" specific fields in "struct kshark_data_stream". 
Is it possible to have this mapping stored in in "struct tepdata_handle" 
instead.

Thanks!
Yordan
