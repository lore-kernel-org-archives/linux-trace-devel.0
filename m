Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FC5DC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 24 Jan 2022 09:50:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236853AbiAXJue (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 24 Jan 2022 04:50:34 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:33570
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236830AbiAXJue (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 24 Jan 2022 04:50:34 -0500
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 987593F17B
        for <linux-trace-devel@vger.kernel.org>; Mon, 24 Jan 2022 09:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1643017832;
        bh=fZjoIlNyh5eB6GQGMsiSzLtY0ZWHeQw2g28bp9uO/pU=;
        h=Message-ID:Date:MIME-Version:Subject:To:References:From:
         In-Reply-To:Content-Type;
        b=vYoS+kn0pIg5baV2OY+bC0dBvHvcPRYZrnd+bTqfyP1boxRAqO71zMllp1KBrvZtE
         nTNdF14h7NJV9CPUlDXWwCXYjMBmmDtYmH+Hh7gUg76Kx+JSmUw71snFJ7Xbc+Kn8y
         2FyA2CmHMcCS5nAT9dNegNSxskUiUJhHaQmBIWt4Fa3MDJ5jeoKQFEfvsEf+E9apse
         EiGu71DGhYcbmn1NQ9KdgKbE/crmOtPP+utNvM9z3fp80u39DsPQsConDwJoBE0QUl
         TY+7cw42JeFJ9SwhZaVuUU26ZQj1FkGmOMikYzm0s28Rxvzqmz5xA+8bu902gnCpXI
         dHWwC3V4O7/nA==
Received: by mail-ej1-f71.google.com with SMTP id 13-20020a170906328d00b006982d0888a4so1846700ejw.9
        for <linux-trace-devel@vger.kernel.org>; Mon, 24 Jan 2022 01:50:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fZjoIlNyh5eB6GQGMsiSzLtY0ZWHeQw2g28bp9uO/pU=;
        b=5GDfoujjSSyO2jgy6VPnc/GS4HBJ9DLMYVRqyoJrcG08bV1kTVfJ5miv4nPWcgfWlL
         OAgg7P6iJvaE+yv4I+IP6q26tNR1RbbWPDtUYtfeyJKWv+n683KA2Ie3Rprg5mhdEVWO
         xsh+zN8eiJIh7oi9h79UiYUQWtds44ms7kdpF0MRSr6u33Ze9PlK8bOQ/uw+QcAGuVuv
         XPEpzrVKmVHBFvjJVC1oD++eiI4Zx4MC3IoFd18jGGwE5TeD+yGv4JxqFvvytkSPLtfT
         ADYU0Qd6qPjOrQH/U5HjV8IcrmuEVoztq61i8sIoPVhUka+LCauREDZZmfPzNdfAD8mx
         vNYw==
X-Gm-Message-State: AOAM530LYqrgnX8FJpHlyR6atnCte+coHtcQvlI6eHM6914RqM7E/nX7
        i7woC2rxUXl0qWGBTE4HOgPPKh1HTNy6dx4k6fFyErML50XIM1gO+WdOKhQir9sIrCQdPl3VqJX
        WTU0jHUGHHHHpHKkcieF6YBKjJMaVcoehyGVjx3Z2DZlNX1C2
X-Received: by 2002:a17:906:c1d8:: with SMTP id bw24mr12048435ejb.286.1643017831971;
        Mon, 24 Jan 2022 01:50:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxG9Qv12+rj2KgWzO88YxpmF4rojJiW/mIH6zU1TjGmKRvYjAlER1nmMLpgOVZXaP20rJb0YA==
X-Received: by 2002:a17:906:c1d8:: with SMTP id bw24mr12048430ejb.286.1643017831828;
        Mon, 24 Jan 2022 01:50:31 -0800 (PST)
Received: from [192.168.0.53] (xdsl-188-155-168-84.adslplus.ch. [188.155.168.84])
        by smtp.gmail.com with ESMTPSA id b16sm4689851eja.211.2022.01.24.01.50.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jan 2022 01:50:31 -0800 (PST)
Message-ID: <09c4880c-fb01-4823-5312-790ebf91b73c@canonical.com>
Date:   Mon, 24 Jan 2022 10:50:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] libtracefs/Documentation: correct instances-affinity
 section body
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        linux-trace-devel@vger.kernel.org
References: <20220124093841.47558-1-krzysztof.kozlowski@canonical.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
In-Reply-To: <20220124093841.47558-1-krzysztof.kozlowski@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 24/01/2022 10:38, Krzysztof Kozlowski wrote:
> Correct the instances-affinity section body error:
> 
>     asciidoc: ERROR: libtracefs-instances-affinity.txt: line 8: malformed name section body
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> ---
>  Documentation/libtracefs-instances-affinity.txt | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 

I see now that Steven already sent a patch for this.

Best regards,
Krzysztof
