Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD27CC32771
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Sep 2022 02:21:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbiIVCVE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 21 Sep 2022 22:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbiIVCVD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 21 Sep 2022 22:21:03 -0400
Received: from mail.codeweavers.com (mail.codeweavers.com [65.103.31.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7055BAA364
        for <linux-trace-devel@vger.kernel.org>; Wed, 21 Sep 2022 19:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=codeweavers.com; s=6377696661; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=5hLlA8Z7Vg/nGtBqop7mWK8B96oKaG6A37rSRhtessI=; b=pSuyJsfRgsKYQ/VE1oFNEJhtar
        FeWvt0qMHV9l4hCfVtkYgkzE3d1rXKQL+qRiiAfenutOEEjQ4bdliuKlUjrMr98erhJLPoInm31xU
        ZEmCUbspIDiPPB4QvaBRnMsVgqJmDn2Y9WbQI2u3lqPd62t+BcLifcFRWFn3qDTaLIzk=;
Received: from 174-20-99-193.mpls.qwest.net ([174.20.99.193] helo=[192.168.0.3])
        by mail.codeweavers.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <zfigura@codeweavers.com>)
        id 1obBpj-0095XX-MO; Wed, 21 Sep 2022 21:20:59 -0500
Message-ID: <9e39d27a-ad6c-422e-0c4d-4a7a0fb7443d@codeweavers.com>
Date:   Wed, 21 Sep 2022 21:20:57 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH] tracecmd extract: Allow using --compression.
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20220901205638.3247090-1-zfigura@codeweavers.com>
 <20220921214941.0d297d5d@gandalf.local.home>
From:   Zebediah Figura <zfigura@codeweavers.com>
In-Reply-To: <20220921214941.0d297d5d@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 9/21/22 20:49, Steven Rostedt wrote:
> On Thu,  1 Sep 2022 15:56:38 -0500
> Zebediah Figura <zfigura@codeweavers.com> wrote:
> 
>> From: Zeb Figura <zfigura@codeweavers.com>
>>
>> This is already supported and works as expected; allow the option to be
>> specified.
> 
> Hi Zeb,
> 
> I'd love to accept this patch, but I need you to add your "Signed-off-by"
> tag.
> 
>    See https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/tree/DCO
> 
> You can either resend the patch, or reply with it here.

Oops, I swear I even specifically remember seeing that in the 
contribution instructions, but forgot to actually add it :-(

Sent as reply.
