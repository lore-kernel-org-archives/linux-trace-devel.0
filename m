Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB121C61DB3
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Jan 2023 14:45:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239954AbjALOpa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Jan 2023 09:45:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239763AbjALOok (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Jan 2023 09:44:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B492551CF;
        Thu, 12 Jan 2023 06:33:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F73B60AB3;
        Thu, 12 Jan 2023 14:33:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 177C1C43396;
        Thu, 12 Jan 2023 14:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673533984;
        bh=qgmHBsfNE9Tsw8m7Rq8qffi4li95nPuRTdlG4ZubwSY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=pK8lKY9KTb+tLMAaplrTTVidaExu6XPbsHPG/sOc4qIDGviGrQ3xSH0jHVe6423Er
         RTxn1WhVXisITscLKNV6JYE/Elg+2/Dkf1G+balXd4H4BstUsWxoZvMgQk0t3fJwGS
         91brxIoHhiBcmk3g6OeBb+G0+5s7cPIIFtxaW4hPn3L0LWOyINVjd+mijlGnrNSlgg
         C24EYL+BuprTKsh6oK29m15H196INXLCGOq+EhXhid97qmyv9NnYSCmB6FHivEH9Kx
         rteP5AMWUiEf0evuD3j00hmDU+hyIz2uJALAJ+FIoOtOGCGkfvEN43xPGmJYO7N+to
         DVj6ZVNleNU+g==
Message-ID: <f5c03cda-420c-e42e-f319-abb90afc8b8f@kernel.org>
Date:   Thu, 12 Jan 2023 15:33:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 2/2 v2] tools/tracing/rtla: osnoise_hist: display average
 with two-digit precision
Content-Language: en-US
To:     Andreas Ziegler <br015@umbiko.net>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <f47e877c-c95f-e3e6-b96f-89b0ca582878@kernel.org>
 <20230103103400.275566-3-br015@umbiko.net>
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
In-Reply-To: <20230103103400.275566-3-br015@umbiko.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 1/3/23 11:34, Andreas Ziegler wrote:
> Calculate average value in osnoise-hist summary with two-digit 
> precision to avoid displaying too optimitic results. 
> 
> Signed-off-by: Andreas Ziegler <br015@umbiko.net>

Acked-by: Daniel Bristot de Oliveira <bristot@kernel.org>

-- Daniel

