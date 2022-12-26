Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96095C3DA79
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Dec 2022 11:50:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231785AbiLZLur (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 26 Dec 2022 06:50:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232031AbiLZLuX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 26 Dec 2022 06:50:23 -0500
Received: from serv15.avernis.de (serv15.avernis.de [IPv6:2a01:4f8:151:30a2::163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CBD0E61;
        Mon, 26 Dec 2022 03:50:18 -0800 (PST)
Received: from webmail.serv15.avernis.de (ip6-localhost [IPv6:::1])
        by serv15.avernis.de (Postfix) with ESMTPSA id A8407BDE8929;
        Mon, 26 Dec 2022 12:50:15 +0100 (CET)
MIME-Version: 1.0
Date:   Mon, 26 Dec 2022 11:50:15 +0000
From:   Andreas Ziegler <br015@umbiko.net>
To:     Slade Watkins <srw@sladewatkins.net>
Cc:     Daniel Bristot de Oliveira <bristot@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: rtla osnoise hist: average duration is always zero
In-Reply-To: <CA+pv=HO1mvnN5XZHkWDjWr=NJHJZxjcstiY4qtJGJ6mfsqPfQw@mail.gmail.com>
References: <d7bb31547e9bbf6684801a7bbd857810@umbiko.net>
 <CA+pv=HO1mvnN5XZHkWDjWr=NJHJZxjcstiY4qtJGJ6mfsqPfQw@mail.gmail.com>
Message-ID: <a900f403176c0e806051efc0f34f2912@umbiko.net>
X-Sender: br015@umbiko.net
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.7 at serv15.avernis.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 2022-12-24 21:17, Slade Watkins wrote:
> On Sat, Dec 24, 2022 at 7:48 AM Andreas Ziegler <br015@umbiko.net> 
> wrote:
>> 
>> -- Observed in, but not limited to, Linux 6.1.1
> 
> Wait, "but not limited to"? What does that mean? Are there more
> versions affected?

This was meant to indicate that the bug is not a regression; it can be 
found in every release since introduction in 5.17. Currently affected 
are 6.1.y and 6.0.y kernel trees.

Regards,
Andreas

> -- Slade
