Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4D72C43334
	for <linux-trace-devel@archiver.kernel.org>; Wed, 20 Jul 2022 12:33:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238734AbiGTMdZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 20 Jul 2022 08:33:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234888AbiGTMdK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 20 Jul 2022 08:33:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3571F75393
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Jul 2022 05:32:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70122B81F2D
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Jul 2022 12:32:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A890C341C7;
        Wed, 20 Jul 2022 12:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658320328;
        bh=QP8kEaBj4X3zo6Q1ZzuY5+ygxl+DusdGKpYm6RpiRWA=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=OqtKUII0mjCGAePmFVVwHEVpU9ZOs9turihFBcdA8Uq5yGZDOMYs0woPRVodILcY7
         bllaeHjzcf0fvK2UH5ni3q+NrFgmRzE8MP7ByzKcDfFl7W5JMQAnxL5Xw76xGjLbO+
         4cx0HJL8v9zr1E9O5vgHf692p3sKK5vHxCjKFvL4svup0wC2aqsJRT+umEhrPeUkkj
         eWMQmlhLDosjzQR71cWSfefL8FEuBYNkyQUGKjyPsMgJiKBYCIy8RYzAgL6OeHR61Q
         Mi1SzIYQx4fphAc824W14h2Vo1Z7HxvhcF7L4gUcKFBeETddLeD10AU3lip1/T8o26
         uIaNLrqbL6yQA==
Message-ID: <63b29e87-a6cd-739a-48c7-fb141f60dc9f@kernel.org>
Date:   Wed, 20 Jul 2022 14:32:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] tools/rtla: Fix command symlinks
Content-Language: en-US
To:     Ben Hutchings <benh@debian.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
References: <YtLBXMI6Ui4HLIF1@decadent.org.uk>
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
In-Reply-To: <YtLBXMI6Ui4HLIF1@decadent.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 7/16/22 15:47, Ben Hutchings wrote:
> "ln -s" stores the next argument directly as the symlink target, so
> it needs to be a relative path.  In this case, just "rtla".
> 
> Fixes: 0605bf009f18 ("rtla: Add osnoise tool")
> Fixes: a828cd18bc4a ("rtla: Add timerlat tool and timelart top mode")
> Signed-off-by: Ben Hutchings <benh@debian.org>

Acked-by: Daniel Bristot de Oliveira <bristot@kernel.org>

Thanks!
-- Daniel
