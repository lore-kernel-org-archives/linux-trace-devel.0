Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49B83C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 24 Jan 2022 09:50:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236852AbiAXJuM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 24 Jan 2022 04:50:12 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:46274
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236830AbiAXJuL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 24 Jan 2022 04:50:11 -0500
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 8D8503F1A3
        for <linux-trace-devel@vger.kernel.org>; Mon, 24 Jan 2022 09:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1643017810;
        bh=yYGz3xoE8ANhJ7w0Kg0nDKOlP1w0h+rWCg+MJ/RahP0=;
        h=Message-ID:Date:MIME-Version:Subject:To:References:From:
         In-Reply-To:Content-Type;
        b=NcufxwCU1/7JoYgre1CKBT3mrOy8cKUzq2xIc2sMub3Rj+nU7bDCG54BhUfXZFUO6
         MATxhj64YTgzfOKqmvievJ2vZOt6OfdqXqHNa9OkMZEyJf+kXJoFPR/nWFs2Ex2Llz
         GkrlPajis4t1tv5nDHVRPvFIMLka30xhv4AQQuXCzUKTPmmJVF2N6rxYqPMudmiyoE
         zUgvSfKuPtvkVhYUjXRct2n3qXLi964IrUZ+7Ce+9jd79ITuGSeEyEwykpnnjMwkpO
         W3UsvrVL8ltHc4dqowY+v7RC6A2CgZQpeezDTLBhwEuZEfWCT3ZJ/uR5jOFELPLTYL
         r90HqscDoN8MA==
Received: by mail-ed1-f69.google.com with SMTP id c23-20020a056402159700b00406aa42973eso5676600edv.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 24 Jan 2022 01:50:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yYGz3xoE8ANhJ7w0Kg0nDKOlP1w0h+rWCg+MJ/RahP0=;
        b=OWHw5RltOV6pQeu8IhqKLMX30UiL/eDhOO1uhUtb3Ih6E+n2uzC+0cfB8GYL5F7tJh
         bMzer5FeKCLcU7LqNygcNH44zePM1Xgt2h6QwvATGTJEWSTP9rdkV5r6I07vET8xz7cy
         w0TJoh4qeDrZTQp4N3QBfBPWLhWlwxtl+4BKyW6jRJY+12o45QSVly0I8FNP/Pei210p
         I2REGtKixHjQnzAiMFXq9CBao0HZQs/AUttjPRlQINCKuTflpfo1Eo5E556IPIYTqj9P
         4nPz13lPynCwhVNp6bMSPAPKUZoxrMGUz6YO+Au7WDWsiN9amEP1yckmB1cQz4SaoYue
         L1+Q==
X-Gm-Message-State: AOAM530dAXDgn2dcL61xArlFpUVW9yewgVfnrP8NYPSEEexkhy9boeVl
        Mq2Fx5lhyknZ1IgqJfMBznb8sIsh0LGa2NjMVHKUuND6Lg8DAMaIA3EoRFiVILcfyicdGl9mf2f
        rr8KQogG1zKmwJOr9BHH2CKjE+3ZinsNClDe71kZLuTZeodjv
X-Received: by 2002:a05:6402:4382:: with SMTP id o2mr15189221edc.38.1643017810120;
        Mon, 24 Jan 2022 01:50:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz7c2s1xp9OBbMwa7ADgT5nAq8GIcpvKcI3R24egaoRP+aiBNN/n7FV11CN4+6/m0VIariBGw==
X-Received: by 2002:a05:6402:4382:: with SMTP id o2mr15189212edc.38.1643017809977;
        Mon, 24 Jan 2022 01:50:09 -0800 (PST)
Received: from [192.168.0.53] (xdsl-188-155-168-84.adslplus.ch. [188.155.168.84])
        by smtp.gmail.com with ESMTPSA id d15sm4742826ejw.143.2022.01.24.01.50.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jan 2022 01:50:09 -0800 (PST)
Message-ID: <105fa0cf-4ef2-68d2-dfe9-cc9f68bd5d8b@canonical.com>
Date:   Mon, 24 Jan 2022 10:50:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] libtracefs: Fix libtracefs-instance-affinity.txt document
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20220119111901.0a18aa2c@gandalf.local.home>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
In-Reply-To: <20220119111901.0a18aa2c@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 19/01/2022 17:19, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> The building of the Documentation directory errors with:
> 
>   DESCEND            Documentation all
>   ASCIIDOC libtracefs-instances-affinity.html
> asciidoc: ERROR: libtracefs-instances-affinity.txt: line 8: malformed name section body
> asciidoc: FAILED: libtracefs-instances-affinity.txt: line 8: unexpected error:
> asciidoc: ------------------------------------------------------------
> Traceback (most recent call last):
>   File "/usr/lib/python3/dist-packages/asciidoc/asciidoc.py", line 6081, in asciidoc
>     document.translate(has_header)  # Generate the output.
>   File "/usr/lib/python3/dist-packages/asciidoc/asciidoc.py", line 1380, in translate
>     self.attributes['manname'] = mo.group('manname').strip()
> AttributeError: 'NoneType' object has no attribute 'group'
> make[1]: *** [Makefile:237: libtracefs-instances-affinity.html] Error 1
> make: *** [Makefile:286: doc] Error 2
> 
> This was due to a cut and paste error and the first line did not have a
> hyphen for the description of the man page.
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>  Documentation/libtracefs-instances-affinity.txt | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>


Best regards,
Krzysztof
