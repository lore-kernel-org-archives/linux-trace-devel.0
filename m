Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CE9CC56201
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Nov 2020 16:04:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0D3B246AA
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Nov 2020 16:04:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EZcPmnZ1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbgKSQEu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Nov 2020 11:04:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727151AbgKSQEt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Nov 2020 11:04:49 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FCB8C0613CF
        for <linux-trace-devel@vger.kernel.org>; Thu, 19 Nov 2020 08:04:49 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id a16so8671026ejj.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 19 Nov 2020 08:04:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yn6a4hnyhDk+uyOK8OVPi2iPtUGW9F2JnPQGxqJu6BQ=;
        b=EZcPmnZ1Cl8mjA8txa2wrp6IGr4Ylg9sF2qLiUb6Bz6j3d6TFNdCFrj+T4TnSwM98M
         CmDkJSVkLjiKujEWwRunsw7wKrn9q8DXMoBClqNoUtGpSUoSVjlTeOGFHteit/60JFqV
         G1TcLb4/XaQLUSSjBX4ajyoRKONJH4+MEALjWYK2/90NBmuBNEH7/ijJoyR7BntWVX6M
         wCKvLLL5F5xrvpjTB005R6bgYuFm6YP0SXAhDH7EtLDe0SKo2GuGSCb8/qLyFuxSMYAd
         FaBB8UBu28Rkey4c3R4ZMRLOSd+bAJw2LHw98TMGmPFw3QekWtiMLojQb4eDB/oTs3EB
         BH9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yn6a4hnyhDk+uyOK8OVPi2iPtUGW9F2JnPQGxqJu6BQ=;
        b=dkzTA/yT/v2U2lSZXOmY/tqPGLxjviTDCBB5+HHEz9KqOIdGu527+0ycztoll9ewvR
         9n+z01mX88xnyx4SdeNrdoCt99rtTv6/Cn2mzgUQRBYaMQYkb4F03UTNpOZVLdn1kxkC
         sodUCpSy2KmxT+ByG4uYifhlUho8KomZcA1VmnZXzt8Wysde4ELFPod4DC6YnKjZ0j8v
         vgAws9hka0F+5EG/Lug9g+UXcpDMRw7vE8QUTMxvXdsPQQH86EWK2Na8DKpMdZlBI/XX
         9mDxUrGwHG0GssBlX63Ls7h1k4hGm9ktkUQiV/UDOWZSAiDuE+TgKxrUfM7CE3gPJ0lu
         iIhQ==
X-Gm-Message-State: AOAM533GmmNAkJ7QydBKVXdZmZ9d/jGxXW5uPSv5/Is6xN2bxgh5Yt+U
        qrIA5z3xeF1Rns5edG6xyM90+vHMfHc=
X-Google-Smtp-Source: ABdhPJz66ulGk5WzOOteJRFjSHEPKMe9C1URrllTrUSTHJR3p1M2xuDWU58eFSmDk6DM6xE/tZY14Q==
X-Received: by 2002:a17:906:5593:: with SMTP id y19mr10281867ejp.343.1605801887939;
        Thu, 19 Nov 2020 08:04:47 -0800 (PST)
Received: from [192.168.0.108] ([84.40.93.58])
        by smtp.gmail.com with ESMTPSA id o17sm12538617edz.10.2020.11.19.08.04.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Nov 2020 08:04:47 -0800 (PST)
Subject: Re: [PATCH v4 06/20] kernel-shark: Add basic methods for Data streams
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20201118145003.156542-1-y.karadz@gmail.com>
 <20201118145003.156542-7-y.karadz@gmail.com>
 <20201118171722.3b305816@oasis.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <68ec2306-b872-cc5a-116f-95fa906ce109@gmail.com>
Date:   Thu, 19 Nov 2020 18:04:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201118171722.3b305816@oasis.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 19.11.20 г. 0:17 ч., Steven Rostedt wrote:
> On Wed, 18 Nov 2020 16:49:49 +0200
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>> +/**
>> + * Bit mask (16-63) used when converting indexes to pointers and vise-versa.
>> + */
>> +#define INVALID_STREAM_MASK	(~((uint64_t) INDEX_MASK))
> 
> This wont work on a 32 bit machine, as pointers are 32 bits not 64.
> 

You are right. I will change this to

#define INVALID_STREAM_MASK	(~((unsigned long) INDEX_MASK))

>> +
>> +static int index_from_ptr(void *ptr)
>> +{
>> +	unsigned long index = (unsigned long) ptr;
>> +
>> +	return (int) (index & INDEX_MASK);
>> +}
>> +
>> +static void *index_to_ptr(unsigned int index)
>> +{
>> +	unsigned long p;
>> +
>> +	p = INVALID_STREAM_MASK | index;
>> +
>> +	return (void *) p;
>> +}
>> +
>> +static bool kshark_is_valid_stream(void *ptr)
>> +{
>> +	unsigned long p = (unsigned long) ptr;
>> +	bool v = !((p & ~INDEX_MASK) == INVALID_STREAM_MASK);
> 
> On 32 bit, the above will always fail, because unsigned long is 32
> bits (as is void *), but INVALID_STREAM_MASK is 64 bits. And the two
> could never equal each other.
> 

Thanks a lot!
Yordan


> -- Steve
> 
> 
>> +
>> +	return p && v;
>> +}
>> +
