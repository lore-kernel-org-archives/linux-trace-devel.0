Return-Path: <SRS0=HSPc=CM=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F189AC43461
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Sep 2020 14:52:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5B8620716
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Sep 2020 14:52:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nRlUjlG/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729156AbgICOwj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 3 Sep 2020 10:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728956AbgICOMi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 3 Sep 2020 10:12:38 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35FC3C0610E2
        for <linux-trace-devel@vger.kernel.org>; Thu,  3 Sep 2020 06:53:59 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id m6so3375326wrn.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 03 Sep 2020 06:53:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3ooYTwrrCrgnLuYhmjc7crBbdIBy/Rm0bQBrh+HsgJg=;
        b=nRlUjlG/+cm/92XN1xFis+KtA3g7yqqvXXgcZ3ONRn6kfo5u2X/+DDLlFLtioIN4Ec
         V13l7gKoZK+eUrLOH3yn2NqxrP3pDdPQ+PlQzIjqqbPZXH/BehSVffMDthBd0AXd7Ade
         E+X7fRrEGcFzWUnPJZuLNOLwvo52I/JkpM4RAamvQEkG9n1inTpC2TuntsZaGjMsiM/H
         bWmZL/oxWiQbkkTn4XU1kJSNpfbDJFbkeWDqgZor3O4vAT5nCPVEz83dCHHK+xhkQpXM
         bLfA3sdOmZEHXOg6II2TS2tugyvwXnTD9sSIJnvmUlx7rWKBGn+c9JwowyNGJ2AaKEjv
         LHqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3ooYTwrrCrgnLuYhmjc7crBbdIBy/Rm0bQBrh+HsgJg=;
        b=K7wh2H3tByj6rSIqMAB+sdJN830dx3gCs7aSFJhJ8rL/3gm++sw++kuG2ApRzYWZs0
         o7jL+heMmL+3UKAhGz6/j2+eEU8eFVFGYC97bnEr2fpF1SQ1e8Jswxk0jrhfsnRUgY0g
         B1U8bSjV4FAD9QivL1V/jPaFEsfUXj59n5UxvDdUFH2eqeurw7UUfvejhd/R9TSfn2dv
         A+q2UtyIKrfeDHzdVCAQF0bIMGnp5E9tj0vlWcvpD1mbGXRGfMi5pvKDahzgH5s416bE
         YxE6uIFZ/Jzl+Rp+3XcGMb0GS8OL3DoQ4FaxapteyewntvgiwA4eHc12zQZs4Jr3mFbH
         t8Sw==
X-Gm-Message-State: AOAM533p+q0lKtlBI5GIOHbZYuamM0DWHiFcovVewW6+PorRA3xNvp2J
        +D8CoGIPPYOoSQDpyssV+4FR5PGXQ/A=
X-Google-Smtp-Source: ABdhPJx3e4M1bhh9fBgHLymhhzNN1j1RyUMje0lVtnO2R6BMvM5gEG4YDlng9HdYSNTQgQjqrc01BQ==
X-Received: by 2002:a5d:48c3:: with SMTP id p3mr2507469wrs.69.1599141237613;
        Thu, 03 Sep 2020 06:53:57 -0700 (PDT)
Received: from [192.168.0.108] ([95.87.199.108])
        by smtp.gmail.com with ESMTPSA id r14sm5064166wrc.41.2020.09.03.06.53.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2020 06:53:56 -0700 (PDT)
Subject: Re: [PATCH] KernelShark: Add guest's stream ID to the combobox item.
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
References: <20200902161118.46163-1-tz.stoyanov@gmail.com>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <5a3cc0b3-5301-22fd-a116-9800dc5ea146@gmail.com>
Date:   Thu, 3 Sep 2020 16:53:55 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200902161118.46163-1-tz.stoyanov@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 2.09.20 г. 19:11 ч., Tzvetomir Stoyanov (VMware) wrote:
> From: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>
> 
> When a new stream is added to the list of guest streams in the ComboBox
> plugin, attach the stream ID to the entry as well. Later, when the
> stream is selected from the list, this ID is used to get information of
> the stream.
> 
> Signed-off-by: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>
> ---
>   src/plugins/KVMCombo.cpp | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/src/plugins/KVMCombo.cpp b/src/plugins/KVMCombo.cpp
> index 4ca33d4..bc3c6b0 100644
> --- a/src/plugins/KVMCombo.cpp
> +++ b/src/plugins/KVMCombo.cpp
> @@ -269,7 +269,7 @@ void KsComboPlotDialog::update()
>   			continue;
>   
>   		streamName = KsUtils::streamDescription(kshark_ctx->stream[sd]);
> -		_guestStreamComboBox.addItem(streamName);
> +		_guestStreamComboBox.addItem(streamName, sd);
>   		color << colTable[sd];
>   		_guestStreamComboBox.setItemData(i, QBrush(color),
>   						    Qt::BackgroundRole);
> 

Thanks Ceco!
The patch is applied.

Yordan
