Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CFC0C6FA86
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Sep 2022 15:25:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbiIVPZc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Sep 2022 11:25:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231977AbiIVPZa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Sep 2022 11:25:30 -0400
Received: from mail.codeweavers.com (mail.codeweavers.com [65.103.31.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1C0EE998E
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Sep 2022 08:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=codeweavers.com; s=6377696661; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:To:Subject:MIME-Version:Date:Message-ID:Sender:
        Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=SBpaTzHQzVrsDtkwuvfZdZMfJTVUz2OSMbyYNu1jrUA=; b=GrYbWqoX/sxaGNqQl5nn2g8gMA
        mVioxqR2h7LzfYnOLTFhaSiIvm+xDawHbXGqwdNYo3bvMW/B5uFrCDvoWK8BgtnFbKLQyCnLXw0ji
        ywl3jFyLxrkHM17N/7iGnKr22hTMp34Ui3piROdLdveUlWkw8PB2Bf3+HpQ6C+BimCaU=;
Received: from 174-20-99-193.mpls.qwest.net ([174.20.99.193] helo=[192.168.0.3])
        by mail.codeweavers.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <zfigura@codeweavers.com>)
        id 1obO4q-009pYb-65
        for linux-trace-devel@vger.kernel.org; Thu, 22 Sep 2022 10:25:27 -0500
Message-ID: <482fa3dc-6dc0-1b0e-fa5e-a97cc9c131d3@codeweavers.com>
Date:   Thu, 22 Sep 2022 10:25:23 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH] tracecmd extract: Allow using --compression.
Content-Language: en-US
To:     linux-trace-devel@vger.kernel.org
References: <20220901205638.3247090-1-zfigura@codeweavers.com>
From:   Zebediah Figura <zfigura@codeweavers.com>
In-Reply-To: <20220901205638.3247090-1-zfigura@codeweavers.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Signed-off-by: Zeb Figura <zfigura@codeweavers.com>
