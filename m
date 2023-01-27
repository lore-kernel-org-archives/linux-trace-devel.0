Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 134CEC54EAA
	for <linux-trace-devel@archiver.kernel.org>; Fri, 27 Jan 2023 08:52:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232525AbjA0IwL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 27 Jan 2023 03:52:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231709AbjA0IwI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 27 Jan 2023 03:52:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F45A19F25;
        Fri, 27 Jan 2023 00:52:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 295EF61A1D;
        Fri, 27 Jan 2023 08:52:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF104C433EF;
        Fri, 27 Jan 2023 08:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674809526;
        bh=+t5XYbDnpxAsQKYfEVg9ILhlr/G87XMZOJrJ3hqtOJ8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=aVpirXyNBq8heMv9meBF89mJ0dtN/TECXW48SLyT6javKFeR/L1rU6dC7wQwU6S1U
         /NtdfR9HrmI50ww6QfKXWqcc5RzIPjTcJ//pKjjfr5znIUGC642l8XycO8RN2Y+NsW
         GZkbm/GEG8FDwxEMppfzpeLjrEPHbJ+MZKQjCuKyQqtVNR1Yc6IXbqFBidkWVU0MDr
         OD3ppYRdFxcpFkcdHkt8NrLaoLY6GhQ3WSSz/L8dgNiZ4e8jGdGj28hLc0HCFrAyo4
         z/KXWE9ZLlUyD9VYuiYdXWSTMBqXrIbt7iUBfc29meeF3RO5hcBUR/RCXpdvEQXH0F
         l488j59dfnaDQ==
Message-ID: <9c9e7846-0521-32eb-153c-0686af5e58ba@kernel.org>
Date:   Fri, 27 Jan 2023 09:52:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 30/35] Documentation: tools/rtla: correct spelling
To:     Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
References: <20230127064005.1558-1-rdunlap@infradead.org>
 <20230127064005.1558-31-rdunlap@infradead.org>
Content-Language: en-US
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
In-Reply-To: <20230127064005.1558-31-rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 1/27/23 07:40, Randy Dunlap wrote:
> Correct spelling problems for Documentation/tools/rtla/ as reported
> by codespell.
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Daniel Bristot de Oliveira <bristot@kernel.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: linux-trace-devel@vger.kernel.org
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: linux-doc@vger.kernel.org

Acked-by: Daniel Bristot de Oliveira <bristot@kernel.org>

Thanks
-- Daniel
