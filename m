Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 147B7C7EE2E
	for <linux-trace-devel@archiver.kernel.org>; Tue, 28 Feb 2023 13:19:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbjB1NTV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 28 Feb 2023 08:19:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbjB1NTU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 28 Feb 2023 08:19:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C789012840;
        Tue, 28 Feb 2023 05:19:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7ED0EB80E19;
        Tue, 28 Feb 2023 13:19:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85CD7C433D2;
        Tue, 28 Feb 2023 13:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677590356;
        bh=o17zWIwbVjctXDAPJBZZB+2irglH1kKe0kNtlumTJJo=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=XikwR7YGfUpH6jNMQVtIZ8TheXMi1bhjj51DbfqUUV4+l50uyJUNrZ53OLSv2Rozn
         lLd/f+x2bE9UNs5NBrlADhz1dij5mAgfuUhwarnrJHqTWhnmfP/S7VZ3Punk3wVzdX
         fbRLVyaJBsjnZ96zy1JL8ObcvVJVF/4BbUI+eS1S+Cu4dGAnh57lV2f0fK0B4L3CzD
         ycNM8yNKy0SyEBoliHJ+DXAFew5p6pxEkpi3n4PBq4SKxFmLNzGFCtQuSQwtiZc2G1
         tKi5UnwFtiDumrJQOEmslQHUIkKhdB9zrPeM+mPq7sLJghQUarfOSDmQ6Od3jLrz6Y
         H/1eKRlNs/ulw==
Message-ID: <3d87834c-0800-b648-157b-ed00ebbce450@kernel.org>
Date:   Tue, 28 Feb 2023 10:19:10 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 14/20] rv/reactor: remove MODULE_LICENSE in non-modules
Content-Language: en-US
To:     Nick Alcock <nick.alcock@oracle.com>, mcgrof@kernel.org
Cc:     linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hitomi Hasegawa <hasegawa-hitomi@fujitsu.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org
References: <20230228130215.289081-1-nick.alcock@oracle.com>
 <20230228130215.289081-15-nick.alcock@oracle.com>
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
In-Reply-To: <20230228130215.289081-15-nick.alcock@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 2/28/23 10:02, Nick Alcock wrote:
> Since commit 8b41fc4454e ("kbuild: create modules.builtin without
> Makefile.modbuiltin or tristate.conf"), MODULE_LICENSE declarations
> are used to identify modules. As a consequence, uses of the macro
> in non-modules will cause modprobe to misidentify their containing
> object file as a module when it is not (false positives), and modprobe
> might succeed rather than failing with a suitable error message.
> 
> So remove it in the files in this commit, none of which can be built as
> modules.
> 
> Signed-off-by: Nick Alcock <nick.alcock@oracle.com>
> Suggested-by: Luis Chamberlain <mcgrof@kernel.org>

Acked-by: Daniel Bristot de Oliveira <bristot@kernel.org>

-- Daniel
