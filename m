Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3407FC4742C
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Nov 2020 13:58:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB2752222F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Nov 2020 13:58:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Admv0E2c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgKMN6q (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 13 Nov 2020 08:58:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726456AbgKMN6q (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 13 Nov 2020 08:58:46 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C34FC0613D1
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 Nov 2020 05:58:46 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id ay21so10833360edb.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 Nov 2020 05:58:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YZ78hazlDQcsvKswGuuOF7vR00+HoejBO81Ne8DmpP4=;
        b=Admv0E2cOdApGPZPILHYYpDfLMpejjfaI01C/+CQEapHM3G+hfUUfG6HLlXaoX2Y1j
         K/J55PSdP4oHEZQGerxTwSBusi2/RfrYH6uW4doF18FJ+Nw0fzBH42WmFaUx0vILFf+2
         zsyIqTXYnG1D+kHQKE8JRcS39+kj6CKX+GRwjMegKhUaqKO66+AZ56oiCgDUnoSYTtNp
         gGVtHoWxIxLqvPuMOid1pgd54euXltRj1FrbtW5Smi+zcpcHIq5wgU9PEZnEqJNHJZNI
         YgODFiryBFWS4zEAGCUOQ0uEiFWdOrigtJ7WU1kIhHt1jSHQjOh9R2fvF6owtNiWGrMH
         4mqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YZ78hazlDQcsvKswGuuOF7vR00+HoejBO81Ne8DmpP4=;
        b=Y7Rz5ZO4Pl8/+DaIEuUrk/YvAmmgBpxLLMzWjZ9WAs6NZ8l/xhRt+0u8gsSbug7c9Z
         HDfP4+SFZkBMEofxzMHIU/tkj6V15MdM7hlTf1nao+5JmXLcVH9QoI7HcqOr7EYiE4+q
         U3f6QqzDTohEimy/AD9W85ApUV7sUtzS56NwJ8GOQrkUWUXSAIcivjSHNFDra/+GYzdp
         F6m5aCigsRiIqRdFthuUCitCa3R6MP0ssud4jAEgpgf1zO9DF0Qe3JXdqMeJFAbc66yc
         pyaoSwpGjVlc1IqhIzGh1kB4pml+lc+QCme+Skx+TKoP4GDgjca/KwYJ4k5dwV52s1jk
         ofYw==
X-Gm-Message-State: AOAM530xA5RJRVsdfg0brEn0chK26qzGsOGYiHLarz1ZUmkqwIFl4Qbg
        IMZ/kP/UQQyXATEqMworUXpqmJ//O8s=
X-Google-Smtp-Source: ABdhPJxsDRhC9oAvKxLGeUNOcNVzEoFB68EvK8uY8dkL+MoUIWQZcW8q9sM9n90Bug/L20YIMZn9xg==
X-Received: by 2002:a05:6402:1214:: with SMTP id c20mr2493712edw.182.1605275924724;
        Fri, 13 Nov 2020 05:58:44 -0800 (PST)
Received: from [192.168.0.108] ([95.87.199.214])
        by smtp.gmail.com with ESMTPSA id w16sm3981150eds.81.2020.11.13.05.58.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2020 05:58:44 -0800 (PST)
Subject: Re: [PATCH v3 08/20] kernel-shark: Add stream interface for trace-cmd
 data
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20201112142358.36821-1-y.karadz@gmail.com>
 <20201112142358.36821-9-y.karadz@gmail.com>
 <20201112171036.2c12fbe9@gandalf.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <e0e89594-dd68-3d4a-014c-22193af5c838@gmail.com>
Date:   Fri, 13 Nov 2020 15:58:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201112171036.2c12fbe9@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 13.11.20 г. 0:10 ч., Steven Rostedt wrote:
>> +	}
>> +
>> +	return next_cpu;
>> +}
>> +
> I'm still looking at this patch, but will have to continue later.
> 
> -- Steve
> 
> 
> 

Thanks Steven!
I will include all corrections in v4.
Y.
