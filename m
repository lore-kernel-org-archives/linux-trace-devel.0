Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9ED1C61DA4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Mar 2023 16:43:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbjCMQn2 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Mar 2023 12:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbjCMQn1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Mar 2023 12:43:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0105EF74D
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Mar 2023 09:43:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3191B811A0
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Mar 2023 16:43:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2D33C433EF;
        Mon, 13 Mar 2023 16:43:22 +0000 (UTC)
Date:   Mon, 13 Mar 2023 12:43:21 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     linux-trace-devel@vger.kernel.org, Daniel Wagner <dwagner@suse.de>,
        Julia Lawall <julia.lawall@inria.fr>
Subject: Re: [PATCH] libtracefs: Fix the label usage in
 tracefs_instance_set_affinity()
Message-ID: <20230313124321.455ffc78@gandalf.local.home>
In-Reply-To: <8a39213e-4707-4a54-0eb8-aac183cfc0b4@web.de>
References: <8a39213e-4707-4a54-0eb8-aac183cfc0b4@web.de>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sun, 12 Mar 2023 21:32:23 +0100
Markus Elfring <Markus.Elfring@web.de> wrote:

> Date: Sun, 12 Mar 2023 21:24:34 +0100
> 
> The label “out” was used to jump to a source code place after some
> failure cases. This implementation detail hindered better exception handling.
> 
> Use more appropriate labels instead.
> 
> * Reorder jump targets at the end.
> 
> * Omit an extra initialisation (for the variable “set”)
>   which became unnecessary with this refactoring.
> 
> 
> Fixes: 987d8c1a62dadff45e6006c4ce5f3bd138842567 ("libtracefs: Add tracefs_instance_set_affinity() APIs")
> Signed-off-by: Markus Elfring <Markus.Elfring@web.de>

Please, stop these patches. I do not feel this type of patch is important
enough for the churn.

-- Steve
