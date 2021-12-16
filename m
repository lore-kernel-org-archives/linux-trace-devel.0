Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6D8EC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Dec 2021 12:43:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236878AbhLPMnz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 16 Dec 2021 07:43:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234189AbhLPMny (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 16 Dec 2021 07:43:54 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70007C06173E
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Dec 2021 04:43:54 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id k37-20020a05600c1ca500b00330cb84834fso1655452wms.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Dec 2021 04:43:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=n3a8vApecCFJpiz3t6RAPQ5VVqr5dUZENjDURZfl2gI=;
        b=Sva22keoOEGZQYznx5UV/8pgJOJo9uRgvZw0swTMsXhOSy8D3TXAdeTHPP9VmfWbBJ
         KJh0bG9ssjPLUMJShQUjZWph9DRcnHt9QtpVXQSMuriFOseTMhzlRhgmwkXHzm3pB0Zq
         tZSSAKtSaoMMy9IKPmchcWLajiHCaSu/67ek8QBDRqSWKQWt1DAhsTNmVDN+gekfvI9X
         OM0TdVjc0tCxeIj8u1xDeBbitQUNda/cWofCZxqMy1v1olO2ONyC6BqvGEP2Wmeot4F3
         Nlszb7vSjxF13HSz1bSdJYZMUzQx/OTGeucoRtZM4nJmObp+PzOL1Uqs5Tj61ey2vBZA
         o50g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=n3a8vApecCFJpiz3t6RAPQ5VVqr5dUZENjDURZfl2gI=;
        b=hTf8fkH4OHI1mQNLo/EOCyglgzfdz3+pYbFZeyApKZQ3VEKk6oBqVpP+0UubGx7bHE
         d0TsnEorlyuY+OJxYzSVZr13Ic/mGpv8o71zEnxnEtNHrdYmc28s1ERzOACR0a6yzdJw
         nJU7Qlq+ziMvhZ+mPPdRkPce8VpZaU7R0nziVR1Ifbg4Ov00JbwHgXnylH4vBm6f9NWq
         FjmmD/pGQa7GUBjYBrlBUbS/eISaTUtcGDJCkZ5oF/gaBmSev2m8L9BKOoxbrCptwTPZ
         3O+Qrv5yQxNI6Qr01vXmQXzEydcFf+F9aQvzaByO2+atS+BZk1aMyJI73vccU8jgs6VJ
         adsQ==
X-Gm-Message-State: AOAM532X8BFdjZOkVZsAdpRRZwF9AL8aqPdaQNu+rCpJ9+KbNdZB9L2s
        E5PnzTuevRXLEdpS3FJo7W0=
X-Google-Smtp-Source: ABdhPJwtNZI9ylok5eZO6Zo2NlPjDp7ouF5MpErxZsMfS34sPvsaIG+Er1AaEk/71iozQwczEtapLQ==
X-Received: by 2002:a1c:1b08:: with SMTP id b8mr4634394wmb.28.1639658633129;
        Thu, 16 Dec 2021 04:43:53 -0800 (PST)
Received: from [192.168.1.6] ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id 9sm6916633wry.0.2021.12.16.04.43.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Dec 2021 04:43:52 -0800 (PST)
Message-ID: <cb81f51d-14d8-c5db-5181-767574fa9cb1@gmail.com>
Date:   Thu, 16 Dec 2021 14:43:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [RFC PATCH 0/1] kernel-shark: Add plugin for handling Xenomai
 cobalt_context_switch.
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Jan Kiszka <jan.kiszka@siemens.com>,
        Hongzhan Chen <hongzhan.chen@intel.com>,
        linux-trace-devel@vger.kernel.org,
        Dario Faggioli <dfaggioli@suse.com>,
        giuseppe.eletto@edu.unito.it
References: <20211216021649.7273-1-hongzhan.chen@intel.com>
 <20211215220327.0daae29e@gandalf.local.home>
 <b4599ebc-7e53-9d95-32ac-448c1cac8a8a@siemens.com>
 <9ac9a1af-6829-425a-7943-755decf7c273@gmail.com>
 <20211216073626.41d6791e@gandalf.local.home>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20211216073626.41d6791e@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 16.12.21 г. 14:36 ч., Steven Rostedt wrote:
> On Thu, 16 Dec 2021 14:29:00 +0200
> Yordan Karadzhov <y.karadz@gmail.com> wrote:
> 
>>> We were just wondering how to handle potential (we have no concrete case
>>> so far) variations of trace points along releases of those "various OSs"
>>> best and were therefore also considering maintaining the plugin in
>>> lock-step with the Xenomai releases. How does KernelShark manage such cases?
>>>    
>>
>> I am adding Dario and Giuseppe to the loop, because they may de interested in this work.
>>
>> We can take the plugin upstream as long as it does not add any xenomai specific dependencies (headers or libraries).
>> In such case you have to guarantee a persistent commitment for co-maintaining it.
>> Alternatively, you can maintain the plugin in a stand alone repository. Dario and Giuseppe are doing this.
> 
> I believe Jan is asking about this stand alone like scenario. Where the
> plugin is actually maintained in the Xenomai repository.
> 
> Is there a way to have the KernelShark user config file automatically load a
> plugin? That way a user could have the plugins they are interested in (that
> are not part of the main repository) automatically loaded every time they
> start KernelShark?

Currently not, but this can be implemented.
Y.

> 
> -- Steve
> 
