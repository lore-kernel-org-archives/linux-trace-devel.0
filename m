Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98D4BC43334
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Jul 2022 19:37:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbiGKThF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Jul 2022 15:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiGKThE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Jul 2022 15:37:04 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C49A2BB36
        for <linux-trace-devel@vger.kernel.org>; Mon, 11 Jul 2022 12:37:03 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 7909558742E7C; Mon, 11 Jul 2022 21:37:01 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 77D9160D6AFEE;
        Mon, 11 Jul 2022 21:37:01 +0200 (CEST)
Date:   Mon, 11 Jul 2022 21:37:01 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Steven Rostedt <rostedt@goodmis.org>
cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtracefs: avoid pointless extra DEP stage
In-Reply-To: <20220708142248.19af0aa9@gandalf.local.home>
Message-ID: <sso89r95-no6o-3p97-582p-n674pn78qsp5@vanv.qr>
References: <20220620150316.21022-1-jengelh@inai.de> <20220708142248.19af0aa9@gandalf.local.home>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Friday 2022-07-08 20:22, Steven Rostedt wrote:

>On Mon, 20 Jun 2022 17:03:16 +0200
>Jan Engelhardt <jengelh@inai.de> wrote:
>
>>  clean:
>> -	$(Q)$(call do_clean,$(OBJS) .*.d)
>> +	$(Q)$(call do_clean,$(OBJS) *.d)
>>  
>> -dep_includes := $(wildcard $(DEPS))
>> -
>> -ifneq ($(dep_includes),)
>> -  include $(dep_includes)
>> -endif
>> +-include *.d
>>  
>
>After this change, the .d files are visible. Is there a way to keep them
>hidden? That is, keep the . in front?

Generally there is. Let me see how to stick
that into the $(CC) line.
