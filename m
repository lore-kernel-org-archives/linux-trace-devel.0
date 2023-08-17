Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70843C5320E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Aug 2023 20:32:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354903AbjHQUbe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Aug 2023 16:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354992AbjHQUbZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Aug 2023 16:31:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32C1835B3
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 13:31:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BADA0633FB
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 20:31:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EC53C433C8;
        Thu, 17 Aug 2023 20:31:15 +0000 (UTC)
Date:   Thu, 17 Aug 2023 16:31:19 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Ross Zwisler <zwisler@google.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH v3 00/18] libtraceeval histogram: Updates
Message-ID: <20230817163119.6cdde89a@gandalf.local.home>
In-Reply-To: <CAGRrVHxQTxNBJ-wTKEgxQb1suhCipWX_ZLk9L3-Hb2MwvWhTfg@mail.gmail.com>
References: <20230817013310.88582-1-rostedt@goodmis.org>
        <CAGRrVHxQTxNBJ-wTKEgxQb1suhCipWX_ZLk9L3-Hb2MwvWhTfg@mail.gmail.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 17 Aug 2023 14:13:52 -0600
Ross Zwisler <zwisler@google.com> wrote:

> >   - Added traceeval_remove() to remove an item from traceveal (opposite of traceeval_insert())  
> 
> I think you've addressed all my review comments, you can add:
> 
> Reviewed-by: Ross Zwisler <zwisler@google.com>
> 
> to the series.  Thanks!

Thanks for taking the time Ross. I'll be posting v4 soon, and hopefully
I'll be able to add that.

Then I have yet another series on top of that!!

-- Steve
