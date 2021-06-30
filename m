Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77198C11F65
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Jun 2021 20:05:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DC3A61351
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Jun 2021 20:05:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233825AbhF3UIW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 30 Jun 2021 16:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233798AbhF3UIV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 30 Jun 2021 16:08:21 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45600C061756
        for <linux-trace-devel@vger.kernel.org>; Wed, 30 Jun 2021 13:05:52 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id gn32so6335821ejc.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 30 Jun 2021 13:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hC3VBv9tGLp2POXljcSQAbzBF99C0t7kfYG5qoyd6yA=;
        b=SR63nLkLN6U4t1yYnynp2nDlhWs2XGVV/nxuOC/0CY99C9WL2rAa9A7SWzTGGlzJ3J
         4KUcuyHPGqPkYTBm6dKz+stSXz9dhTkIHLL4K+es9h56QsFZLxTzK+BvdRWU11LBV/ke
         s8iQVQ8DnZReG9yXl2XKEujq0nFbxedS3uSCXfwu6hfx+0MiaBCPyteuSltyGo8MqvhD
         Ndh3IYieSXiHUDcWiXHN8bpRiBuDa7AxLoVdybvdhEWkybOhxogdouhqpQmm2/zy+Elz
         ixuJw3V67Vo4d0MBYZlzSq3+ZYj/w3+KkUmESjJIdgQ5y7pGAQS+6dukUwOG7dtfMNAz
         wMaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hC3VBv9tGLp2POXljcSQAbzBF99C0t7kfYG5qoyd6yA=;
        b=GqhptZe/jlbkDAt+Ly1f1nwFNVWuy4gEQ7uQoIlJdw14meTRA7gPp+Ia+ZqYPPe/F3
         Wp+Mp4Rv91cHBNILcj0d5JU9NkddR4+r3nG7rU3H3wcyUeoNb4wX0SLq52PKq/vERJ8T
         neQlmgHcmAyTpPhZxnqnSJMD7RoUSr17M2YIb8dcvqaONGga307nbM+xZXJS3BXH73Ht
         LzbQuzCQSNGmp57RthaPZSw4Cp46we5P6dPHDYMaQOQL6YiDYTyQg9iZJEYSDQlL3LiG
         TsrNXFmcIHFUK+PXY1z+JdOsaMuB5u2yZF9PplMTCiqum0eMljuvlljsW+NbThqzrLyr
         ITPQ==
X-Gm-Message-State: AOAM533wa3kafGN2eCjN7p14KWMQ3ZT/DX8EwIldv+o4tZltfDwIkGya
        ppMz3K5L39xUHL2duAILeTyj8CjQ1MA=
X-Google-Smtp-Source: ABdhPJzfOJf+BHefwQIsAP4+Hzehme1W9awbhTT/czny0XOgVqDtsSBF6abrgwBzZ8HwPGwq497Jrg==
X-Received: by 2002:a17:907:a073:: with SMTP id ia19mr13151500ejc.292.1625083550677;
        Wed, 30 Jun 2021 13:05:50 -0700 (PDT)
Received: from [192.168.0.109] ([84.40.73.10])
        by smtp.gmail.com with ESMTPSA id zd21sm2931241ejb.50.2021.06.30.13.05.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jun 2021 13:05:50 -0700 (PDT)
Subject: Re: [PATCH v2 2/4] libtracefs: Implement tracefs_kprobe_raw()
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20210630154729.129873-1-rostedt@goodmis.org>
 <20210630154729.129873-3-rostedt@goodmis.org>
 <83cee0b8-b9c6-849b-291e-b750815de69e@gmail.com>
 <20210630155354.5f58d68b@oasis.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <d03bfad4-e901-1771-7806-67726c088938@gmail.com>
Date:   Wed, 30 Jun 2021 23:05:49 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210630155354.5f58d68b@oasis.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 30.06.21 г. 22:53, Steven Rostedt wrote:
> On Wed, 30 Jun 2021 22:46:19 +0300
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>>> +int tracefs_kprobe_raw(const char *system, const char *event,
>>> +		       const char *addr, const char *format)
>>> +{
>>> +	char *str;
>>> +	int ret;
>>> +
>>> +	errno = EBADMSG;
>>> +	if (!addr || !format)
>>> +		return -1;
>>> +
>>> +	if (!event)
>>> +		event = addr;
>>> +
>>> +	if (system)
>>> +		ret = asprintf(&str, "p:%s/%s %s %s\n",
>>> +			       system, event, addr, format);
>>> +	else
>>> +		ret = asprintf(&str, "p:%s %s %s\n",
>>> +			       event, addr, format);
>>
>> I wonder what will be the way to register a "return value" ("r:")
>> kprobe. Do you consider having a separate API for them?
> 
> Yes, I was thinking about having a "tracefs_kretprobe_raw()" as well.
> 
> I also thought of adding a flag in the parameter, but thought that a
> separate function would be better instead.
> 
> I wanted to play with this interface before creating the retprobe one.
> If you are happy with the current design, I can add that too.
> 

The design looks good to me.

Thanks!
Y.

> -- Steve
> 
