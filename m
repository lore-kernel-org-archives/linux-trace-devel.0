Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86E9BC433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Apr 2022 13:12:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236187AbiDHNOF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Apr 2022 09:14:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236540AbiDHNNr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Apr 2022 09:13:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5A02124A74D
        for <linux-trace-devel@vger.kernel.org>; Fri,  8 Apr 2022 06:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649423406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F6zQPUV2PlrHGRSviwyJlofSDRUyDcipHnyWs+t/Z1c=;
        b=bPMGwiyTmEfo8C8vQRRJfRym39Zfbhgf4+FhnAiCogPHHpDTmj2jHCxmekyOQPJzTkaLbc
        rj9fb+AqsOc8pbvFM7+5BKYJDD2XWXFdBT9xWJy4OX492Jp/rPFAFuq47OzMkz86i0TAgH
        GtVihh0D/xuPmVjHjCJpqxav6rrSfkY=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-520-gAw-aT1eOUaEfrhGoSesLw-1; Fri, 08 Apr 2022 09:10:05 -0400
X-MC-Unique: gAw-aT1eOUaEfrhGoSesLw-1
Received: by mail-ed1-f69.google.com with SMTP id bd16-20020a056402207000b0041d30700755so757986edb.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Apr 2022 06:10:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=F6zQPUV2PlrHGRSviwyJlofSDRUyDcipHnyWs+t/Z1c=;
        b=icsjkEtmJOXnGQWCFwZdNzdpIWc0Z+fWnf6Ak9rrGKca6MEhRCIHbbJQ6q56zJ17EG
         kqGoLwnp0ofA6a5fi8x2V21GDniD2hgwlgTUNwpQ91s72hcPedngX55eXqFt5cjRVnx7
         aLBGKUbo9I2WkpvVnl98FMo74XfuZTZ+aMlTUKtHBNKg9Hulcdknu27uoMBw1UdeVDFb
         5tC+E/YX2ZBk+FHXwad3vfpJOKyQ9qEau/yhqv31t0J79udMuYgq8qWi05utQjB21Nyx
         Q+3t298eoN5gh+u8GYyYNJStnCpUJjW6YLi8Qi1T4K3A5pmf/i0qHxj79gtLXX64vLmJ
         UbqQ==
X-Gm-Message-State: AOAM531+2uo2tErcuUcrgtJ5DcrF3ddzAW/D0090G3x3+7ci4w5LMzpc
        aH3F7clr2OUA45vqW+U7wq1wnSj6V5wMw6bDBeCCUWEA3zgYUE/qcD/fYq7av7CNAIDB1RYqS0R
        k75aC3puXyQG5e9XOZRGsDRRlJm2qX+A=
X-Received: by 2002:a05:6402:1811:b0:41c:d21a:4096 with SMTP id g17-20020a056402181100b0041cd21a4096mr19328845edy.389.1649423404236;
        Fri, 08 Apr 2022 06:10:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxn7MP9IA7yyDw5LXL1ocCfgDAs6gLE3DYeEm4wur52ay4RHHoQP9A+hUSUwLYwXmMU7zcaow==
X-Received: by 2002:a05:6402:1811:b0:41c:d21a:4096 with SMTP id g17-20020a056402181100b0041cd21a4096mr19328820edy.389.1649423403995;
        Fri, 08 Apr 2022 06:10:03 -0700 (PDT)
Received: from [10.0.0.45] (host-95-245-33-130.retail.telecomitalia.it. [95.245.33.130])
        by smtp.gmail.com with ESMTPSA id gv55-20020a1709072bf700b006e82ef9b910sm1880289ejc.70.2022.04.08.06.10.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Apr 2022 06:10:03 -0700 (PDT)
Message-ID: <24f79a7c-0146-ad0a-988a-608edd402faa@redhat.com>
Date:   Fri, 8 Apr 2022 15:10:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 2/2] rtla: Minor fix to grammar in README.txt
Content-Language: en-US
To:     John Kacur <jkacur@redhat.com>
Cc:     lkml <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        linux-trace-devel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
References: <20220402043939.6962-1-jkacur@redhat.com>
 <20220402043939.6962-2-jkacur@redhat.com>
From:   Daniel Bristot de Oliveira <bristot@redhat.com>
In-Reply-To: <20220402043939.6962-2-jkacur@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 4/2/22 06:39, John Kacur wrote:
> "The rtla" doesn't make sense, change it to "The rtla tool"
> This is better than removing the word "The" since some packaging tools
> need the description to start with a capital letter.
> 
> Signed-off-by: John Kacur <jkacur@redhat.com>
> ---
>  tools/tracing/rtla/README.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/tracing/rtla/README.txt b/tools/tracing/rtla/README.txt
> index 6c88446f7e74..3b809eeff5f9 100644
> --- a/tools/tracing/rtla/README.txt
> +++ b/tools/tracing/rtla/README.txt
> @@ -1,6 +1,6 @@
>  RTLA: Real-Time Linux Analysis tools
>  
> -The rtla is a meta-tool that includes a set of commands that
> +The rtla tool is a meta-tool that includes a set of commands that

I do not like bike-shedding but 'the rtla tool is a meta-tool" sounds repetitive.

Does:

The rtla meta-tool includes a set of commands...

sound good for you?

-- Daniel

