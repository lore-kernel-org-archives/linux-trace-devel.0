Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9652C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Apr 2022 13:12:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232913AbiDHNON (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Apr 2022 09:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234459AbiDHNN4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Apr 2022 09:13:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8B0A8D40
        for <linux-trace-devel@vger.kernel.org>; Fri,  8 Apr 2022 06:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649423503;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oOFlqhY22jYsoq+ob7xKTzQP+SCAy2ygHB8Qj3FLlrk=;
        b=M+l2FPwIdUfnUJFBtRKVZBw1aqyudv8/Y8mb3roZ9yK3LkM/LnB4KVsZe2iRfgojcRkTIR
        nJ+VYy/w6y7HKE2yn1mqrxmKVwcaWIGGMYc3tvQxHGSFl13AbKynJzb29GfumqnsDnqbtt
        hiC8igPmGeRTubFMd9eBDt3It/pqwjw=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-377-TLYDahYRNhuyaw0GhpyuNA-1; Fri, 08 Apr 2022 09:11:41 -0400
X-MC-Unique: TLYDahYRNhuyaw0GhpyuNA-1
Received: by mail-ej1-f70.google.com with SMTP id sa33-20020a1709076d2100b006e7f59d3cc0so669095ejc.15
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Apr 2022 06:11:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=oOFlqhY22jYsoq+ob7xKTzQP+SCAy2ygHB8Qj3FLlrk=;
        b=EKi1GBQwXfVehQT7iR3PoTZs0vM4J+bFQSiaI/QQWxZcJOFceaA0miwCtdgIppyHqY
         xLFbnQuus+aY0FMgXaoM57uiI17hWHO1DdERLhDdfHyPYqKEBgjsSGn0UjrEYdoxQTGv
         phAEq5ACn81OCobaKgz88rkeb/8MNaL4WSY1TDCyIBbB6qJlgF/VYhtOYfayDT1IBUP2
         i+4VjIdcM6FTOIK6+exM52V8EszBLtNapI/luaXiKPn6xvMkDxhle1JGnDW3CbSDZFKG
         l8R1EaRylWtWdSh//4XCJU2m+uH1T1A8LYTyr4GTTdDcWZ58OxIxmPsmFPneiLaRgjHz
         T4kw==
X-Gm-Message-State: AOAM5302L32nucTpKFGyHmNHYLI0OyZKcpCT5F5RLOT3Cy77qjxj78QP
        TJyQwBYuk983zlmW1jL1pszyOUntrLIABoMM9bMOLLd8E/OWYHGnWpwwEsVzXXypn2brwu/OKCG
        7nkaxFWn/eyhV66V0SIZUzdzvjCQK/Sc=
X-Received: by 2002:a17:907:8688:b0:6d2:c19:e1a0 with SMTP id qa8-20020a170907868800b006d20c19e1a0mr17642065ejc.249.1649423500618;
        Fri, 08 Apr 2022 06:11:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwGqWMXtLxjkDiB9O5FvZYY9poEXz7xmy/mjbGXXrp6fd6M5rVBrNzOmCmqPPF0uyeM5Pww/A==
X-Received: by 2002:a17:907:8688:b0:6d2:c19:e1a0 with SMTP id qa8-20020a170907868800b006d20c19e1a0mr17642050ejc.249.1649423500417;
        Fri, 08 Apr 2022 06:11:40 -0700 (PDT)
Received: from [10.0.0.45] (host-95-245-33-130.retail.telecomitalia.it. [95.245.33.130])
        by smtp.gmail.com with ESMTPSA id n19-20020a170906165300b006a625c583b9sm8747089ejd.155.2022.04.08.06.11.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Apr 2022 06:11:40 -0700 (PDT)
Message-ID: <06ee8466-ffb9-20f5-f66b-3c36e45b1488@redhat.com>
Date:   Fri, 8 Apr 2022 15:11:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 1/2] rtla: Don't overwrite existing directory mode
Content-Language: en-US
To:     John Kacur <jkacur@redhat.com>
Cc:     lkml <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        linux-trace-devel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
References: <20220402043939.6962-1-jkacur@redhat.com>
From:   Daniel Bristot de Oliveira <bristot@redhat.com>
In-Reply-To: <20220402043939.6962-1-jkacur@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 4/2/22 06:39, John Kacur wrote:
> The mode on /usr/bin is often 555 these days,
> but make install on rtla overwrites this with 755
> 
> Fix this by preserving the current directory if it exists.
> 
> Signed-off-by: John Kacur <jkacur@redhat.com>

Acked-by: Daniel Bristot de Oliveira <bristot@kernel.org>

Thanks!
-- Daniel

