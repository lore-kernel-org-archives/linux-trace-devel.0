Return-Path: <SRS0=9Vf/=C6=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7702AC43463
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Sep 2020 04:23:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39CD82086A
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Sep 2020 04:23:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gbUvlhQN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbgIUEXG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Sep 2020 00:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbgIUEXG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Sep 2020 00:23:06 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0D49C061755
        for <linux-trace-devel@vger.kernel.org>; Sun, 20 Sep 2020 21:23:06 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id x22so3357713pfo.12
        for <linux-trace-devel@vger.kernel.org>; Sun, 20 Sep 2020 21:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=gCHirv/uRmUO47dFGR5EvBlRtSZBYsDYsmxo6gY2BO0=;
        b=gbUvlhQNcDlBqIjcb2l/f+dC6qF4iZjK3LtQWx9IT5CahAnCQZ7wOjMit0vuDX4znx
         XlPqHFV/eOaSr38DxOSidhI0ruLc5Ruver6JmgrbGUY5Np2vO/kDqg6GipcrjH5IeP1h
         j6ho2GD73Hnnv1qJ4SN5xFlERko1ZzBbWweolmRgNiXvsdutAniU8OozWcqi+jIgUfd/
         W0m/Eclk3MJl6KPb3mWywnVNEb6X3jhOWUdo3JP/0b9XgYDwqWWSjwwKvwe5mphwThZ6
         vYzo91ifEQDRvQ1OdkKW26kF2kyEDCI645AX1VuW/Sbb8WeJIsWBqUmqzdoLAhvpYP2P
         jptw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=gCHirv/uRmUO47dFGR5EvBlRtSZBYsDYsmxo6gY2BO0=;
        b=K+yhMeytAFrCvkRo1gppht2O9NnAIYGzoKjcmOjBU1JAMIxsPppnNgJsgFXceqpwhb
         SE5lo+EAfH08MUkXXj9VOmdaxHNObdbC2ibTovTLS/wDW8KIoDXybbgK8UX7Vaa35tgc
         stYdZV/veTyf6r0IUSvRJarLszINho5LfH5dbIkz5Dwwon9bgpr7g036GruGP6qZKdbC
         Cdr4YuCeY+5sCCtEjN77tHU5cFtVLZUunGRW8qjJiJ/kLBvtXXibq0pRXbDc8atVNLoj
         YW3d3t7IShy0gw9l/4J/Eqerx5ozl1ErY5G9itWV3K96EGGxuNhtg7pgKPyeZ/HOQsMf
         gMZw==
X-Gm-Message-State: AOAM530rW780oA35zq2I4BdXLEvPg2oanW8M9JkfQhOBMT7YPI82Vrvn
        JPmSIWhlOBwFJhZu3wqScwZur7R9Qd29+FvRQHp5ITny1LZtPSpj
X-Google-Smtp-Source: ABdhPJwSUplctXzPe7hyc1b1kP0WHECG5kytdx7zUlhwhmpCjqzVa6SHcCAvADDWBMlC8Du/B7exBKa6NfcXqQ+MwyY=
X-Received: by 2002:a63:5656:: with SMTP id g22mr34535331pgm.44.1600662186183;
 Sun, 20 Sep 2020 21:23:06 -0700 (PDT)
MIME-Version: 1.0
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 21 Sep 2020 07:22:50 +0300
Message-ID: <CAPpZLN5k-SRynd=q-dD4swu2qkqx3FE1_MLkB0x9bN=77hmsdA@mail.gmail.com>
Subject: libtraceevent internal functions
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Steven,
While I was working to hide non API libtraceevent functions from the
users, as Ben Hutchings suggested, I found these - they are declared
as official APIs in event-parse.h, but are not described in the man
pages. We should decide - are they APIs, so we should add them into
the man pages, or are internal functions and we should hide them.
   tep_peek_char
   tep_load_plugins_hook
   tep_print_printk
   tep_buffer_init
   tep_get_input_buf_ptr
   tep_get_input_buf
   tep_read_token
   tep_set_test_filters
   tep_add_plugin_path
   tep_plugin_print_options
   tep_free_token
   tep_print_funcs

-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
