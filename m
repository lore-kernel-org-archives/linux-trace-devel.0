Return-Path: <SRS0=58xy=ST=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09A9FC282DA
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Apr 2019 13:44:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C782C20872
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Apr 2019 13:44:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QcPIqxJC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729453AbfDQNoW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Apr 2019 09:44:22 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36717 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729395AbfDQNoW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Apr 2019 09:44:22 -0400
Received: by mail-wm1-f67.google.com with SMTP id h18so3710052wml.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 Apr 2019 06:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=8HKyUFkoQgHd3ytzOBTOjSd8DF4ffOD6c760D1maM/c=;
        b=QcPIqxJCsrRLPCtZzCqw+ubwPkOv+1wRU02fZGm6YK1aUUw+E7XkgRMwprWW/WwgM8
         blEa8ifkowPgctmevHHZ6OLvbTQPxwsuwX/iIwQ2mD7Fgs3SlZm9ywIHHQLEqK0weF6F
         w81IVUaeivxiyVblhhkscEugdY7G3FKAVAPJ/CZ1TNZ9hDJp31zz/ZTzt4RostuoNuY/
         HnpS467xjSq5TdEMIRGuTBmsBzucoauOV5x/FUVRhZG1auDFYdNpVtc3EVoLxGZT4VKN
         XiY5ZPZZaCQ0Ff8LxTstmgSmJtzgmQ2bIRLBTo2jhG7FpWyTApyB0RhqfU7d1G3WilMS
         qx1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=8HKyUFkoQgHd3ytzOBTOjSd8DF4ffOD6c760D1maM/c=;
        b=Y7rzivN1gzO6cD7xRGPsaXMs9ne+4croPo0m799YLwdmnwxVtnvL87ynQVJAWvGJ44
         6dpRlkwFLR4E6djyUeRuGvgcYJWtDzPkQG075FwWMjCx41aneWY3GERrJfH3cpyO56r3
         wliMApUQ//mN3AVf9HwuUqHw9GNTCZQLlN50ZY+cwnFxgrxsKHCE0diA5BeMV8J0qyUr
         y9on1VXZ7JWPr9kyQz5/OFeAvMCVwf11YgKb7zHCU8/4IdyjWcyNA8vU7y/YpnZU8J0b
         cdbxWT0qmtam0W4z1PU5YOYcbQPia1xKk12GuOjC5SS7mIcCWxOsp4e5A5IyVGaY+MLk
         pvBg==
X-Gm-Message-State: APjAAAUfg+7+hHFOaoV4Zy2a02Wuglvgraw1FaqDZOYGIZfMDpO9xeGJ
        DwpuOIs9MpVWFZRZJw0how==
X-Google-Smtp-Source: APXvYqysRcLlvcUQlfgjoBlpHy2UOzu4BMuoemvsX8apV3owNBoqqCgjV6nblRWiN/KWGPOllequ/Q==
X-Received: by 2002:a1c:cf0b:: with SMTP id f11mr30552803wmg.26.1555508660549;
        Wed, 17 Apr 2019 06:44:20 -0700 (PDT)
Received: from box ([151.251.252.188])
        by smtp.gmail.com with ESMTPSA id e7sm3623841wme.37.2019.04.17.06.44.16
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 17 Apr 2019 06:44:17 -0700 (PDT)
Message-ID: <53f5d46695a66aaf103a31817855629675f4938b.camel@gmail.com>
Subject: Re: [PATCH v3 1/2] trace-cmd: Optimize how pid filters are expressed
From:   Slavomir Kaslev <slavomir.kaslev@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org, pauld@redhat.com,
        ykaradzhov@vmware.com, jbacik@fb.com, tstoyanov@vmware.com
Date:   Wed, 17 Apr 2019 16:44:11 +0300
In-Reply-To: <20190416174810.50d8a88d@gandalf.local.home>
References: <20190415230016.13932-1-kaslevs@vmware.com>
         <20190415230016.13932-2-kaslevs@vmware.com>
         <20190416174810.50d8a88d@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.1-1build1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 2019-04-16 at 17:48 -0400, Steven Rostedt wrote:
> On Tue, 16 Apr 2019 02:00:15 +0300
> Slavomir Kaslev <kaslevs@vmware.com> wrote:
> 
> >  static char *make_pid_filter(char *curr_filter, const char *field)
> >  {
> > +	int curr_len = 0, last_exclude = -1;
> 
> Small nit. Usually when adding multiple variables on one line like
> this, the variables should be related. Because curr_len and
> last_exclude are not related, it is best to keep them separate.

Sent v4 addressing those and added a section about --no-filter to
trace-cmd record's man page.

Cheers,

-- Slavi

