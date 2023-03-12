Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1940DC6FA99
	for <linux-trace-devel@archiver.kernel.org>; Sun, 12 Mar 2023 16:24:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbjCLQYj convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 12 Mar 2023 12:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231148AbjCLQYP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 12 Mar 2023 12:24:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 642A232E4F
        for <linux-trace-devel@vger.kernel.org>; Sun, 12 Mar 2023 09:23:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60B4860F55
        for <linux-trace-devel@vger.kernel.org>; Sun, 12 Mar 2023 16:22:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4163EC433D2;
        Sun, 12 Mar 2023 16:22:34 +0000 (UTC)
Date:   Sun, 12 Mar 2023 12:22:32 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        linux-trace-devel@vger.kernel.org, Daniel Wagner <dwagner@suse.de>,
        Julia Lawall <julia.lawall@inria.fr>
Subject: Re: [PATCH] libtracefs: Fix the label usage in
 tracefs_instances_walk()
Message-ID: <20230312122232.7e88d259@rorschach.local.home>
In-Reply-To: <4c0d9f08-2250-c7c4-4fb3-b10353be2941@web.de>
References: <4c0d9f08-2250-c7c4-4fb3-b10353be2941@web.de>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sun, 12 Mar 2023 15:45:21 +0100
Markus Elfring <Markus.Elfring@web.de> wrote:

> Date: Sun, 12 Mar 2023 15:23:09 +0100
> 
> The label “out” was used to jump to a source code place after two
> failure cases despite of the implementation detail that the variable “dir”
> contained still a null pointer.

What's wrong with that?

> 
> Use a more appropriate label instead.
> Delete a pointer check and omit an extra variable initialisation
> which became unnecessary with this change.
> 
> This issue was detected by using the Coccinelle software.

No, the code is fine *as is*!

> 
> Fixes: 9150bc5fab4204392440b82b74e046e40723488c ("libtracefs: Add new tracefs API tracefs_instances_walk()")

It fixes NOTHING!

> Signed-off-by: Markus Elfring <Markus.Elfring@web.de>
> ---
>  src/tracefs-instance.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
> index 57f5c7f..952728e 100644
> --- a/src/tracefs-instance.c
> +++ b/src/tracefs-instance.c
> @@ -694,7 +694,7 @@ int tracefs_instances_walk(int (*callback)(const char *, void *), void *context)
>  {
>      struct dirent *dent;
>      char *path = NULL;
> -    DIR *dir = NULL;
> +    DIR *dir;
>      struct stat st;
>      int fret = -1;
>      int ret;
> @@ -704,11 +704,12 @@ int tracefs_instances_walk(int (*callback)(const char *, void *), void *context)
>          return -1;
>      ret = stat(path, &st);
>      if (ret < 0 || !S_ISDIR(st.st_mode))
> -        goto out;
> +        goto put_tracing_file;
>  
>      dir = opendir(path);
>      if (!dir)
> -        goto out;
> +        goto put_tracing_file;

out is a perfectly fine label. In fact, because it is the normal path,
it is what I use. Don't change it!

> +
>      fret = 0;
>      while ((dent = readdir(dir))) {
>          char *instance;
> @@ -727,9 +728,8 @@ int tracefs_instances_walk(int (*callback)(const char *, void *), void *context)
>          }
>      }
>  
> -out:
> -    if (dir)
> -        closedir(dir);
> +    closedir(dir);
> +put_tracing_file:

I'm fine if the patch just moves the out label, and removes the dir = NULL,
but the label remains as "out:". And it's a clean up *not* a fix!

-- Steve


>      tracefs_put_tracing_file(path);
>      return fret;
>  }
> --
> 2.39.2
> 

