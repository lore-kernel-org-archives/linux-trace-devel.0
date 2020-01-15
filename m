Return-Path: <SRS0=5FGG=3E=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51B23C32771
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 Jan 2020 18:48:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29FC52084D
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 Jan 2020 18:48:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q7t+obkp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729057AbgAOSs0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 15 Jan 2020 13:48:26 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:38021 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728904AbgAOSsZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 15 Jan 2020 13:48:25 -0500
Received: by mail-ed1-f65.google.com with SMTP id i16so16474675edr.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 15 Jan 2020 10:48:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ew2CPolWXSZVhdk1VrWruR+NJlJlgbO2OL3mNHcPZQw=;
        b=q7t+obkpPOz/e9l4moSIC1Nkc3AtNwXbWlbRiGVcqV1rem4RIcVGRRacorFzAoRq7+
         XH3yVdqVcYvMtQ/gEQCUkCeA/Jtw/1cQxsq5YPTywR0wpwqxN1U283mnUv663N90ri1M
         /kIjoMLpP7f3bCyXljpxbgfoX9McmaRGHcKmw74jid7GqYA3D94ai8iWvfCF8gWNc51G
         +Fa5MSLMlMSWRI4EA/3o3XrQp8SosPzsX0mT527zHLzcPge93PQASyGbzt0uPc6+hTjx
         K5ZPoEudtH+h46NWJI4eJTrq3ziXgLK3WYj0Kskc93b2T/HqNmiV82A2rh2LRwc6dKUo
         8EEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ew2CPolWXSZVhdk1VrWruR+NJlJlgbO2OL3mNHcPZQw=;
        b=P6Qg5ELak1Xlr/gKAU48u5sAzG5kPNUXn/D1mayJSD0CQEhjkUaAE8z3EDQKp1Ea6W
         G4s6AlY0be4cHZvKgZFwoX1LgG6mCJ8HqG9fhgKizW468OODuhzkpxuAiPLJ0oAcGr+a
         ZFACvmziXkFBVYL+ztRbIUERGobjB7mm4zUbKWm7UIoyOwbtkCRsncg+RfedugvBlqp7
         /MqcfvXumXu++ufQ7Q5EwIRuO1TrZ3l/M3s3cz/VbJd/TIdO0uALoUu5bnGniYqpBjSh
         yZOq6a9I2/oCnBaEttLK7p/wjhevXKiQzNeGMNUuRaBjHWnoCFK+fFdEKRyAT6v6vZ/0
         9SQA==
X-Gm-Message-State: APjAAAUhViiMMlSFflpStgrRk7mm2/smru33ZFzFyeeCndM/z01uAhTj
        ZbYZstG7SA5mthryDNLoBht+518Rcs1PlfnGMnzwiH4ocnuUBw==
X-Google-Smtp-Source: APXvYqxGT0rIWh6XF02nDARfNgarx0yIg3CkOfcqVJYefAS1b/a/P+AWpCekM1EgBxzboJc7Dojctjep7NJqHAOnTZo=
X-Received: by 2002:aa7:d4d2:: with SMTP id t18mr31880127edr.223.1579114103411;
 Wed, 15 Jan 2020 10:48:23 -0800 (PST)
MIME-Version: 1.0
References: <CAJ8z9b1RD4gyPg8_B2sW=ULEjLRLTZrCAWc=k2=d8wSrhMBbOQ@mail.gmail.com>
 <20200115180645.53331-1-john.koepi@gmail.com>
In-Reply-To: <20200115180645.53331-1-john.koepi@gmail.com>
From:   John Koepi <john.koepi@gmail.com>
Date:   Wed, 15 Jan 2020 20:47:47 +0200
Message-ID: <CAJ8z9b0fHwOUgF_AgXED3wuZpOVbQTfGA3WkNbNFCmiY_Br3Tw@mail.gmail.com>
Subject: Re: [PATCH bpf] traceevent: ignore __attribute__ in fields format
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

I am not sure this is the right mailing list (I was not sure about
@netdev). If it is not - I am sorry, I can resend it. The test for
this change is at https://github.com/sitano/traceevent_attribute.

On Wed, Jan 15, 2020 at 8:06 PM Ivan Prisyazhnyy <john.koepi@gmail.com> wrote:
>
> To support kernel (e.g. Arch linux) tracing that
> have events fields with C attributes (__attribute__((xxx))),
> traceevent must ignore __attribute__ parts when
> parsing fields types.
>
> An example from Arch linux kernel 4.2:
>
>   $ cat /sys/kernel/.../sys_enter_io_submit/format
>   ...
>   field:struct iocb __attribute__((user)) * ...
>                     ^^^
>
> This fix adds support for fields types C attributes
> parsing to event_read_fields function. When it sees
> __attribute__ ((attribute-list)) expression it skips
> it.
>
> Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=205857
> Base: https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git/
> Signed-off-by: Ivan Prisyazhnyy <john.koepi@gmail.com>
> ---
>  tools/lib/traceevent/event-parse.c | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
>
> diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
> index beaa8b8c08ff..fbc1ea536742 100644
> --- a/tools/lib/traceevent/event-parse.c
> +++ b/tools/lib/traceevent/event-parse.c
> @@ -1486,6 +1486,28 @@ static int event_read_fields(struct tep_event *event, struct tep_format_field **
>                             (event->flags & TEP_EVENT_FL_ISFTRACE &&
>                              type == TEP_EVENT_OP && strcmp(token, ".") == 0)) {
>
> +                               /* ignore C attributes: __attribute__((expr)) */
> +                               if (strcmp(token, "__attribute__") == 0) {
> +                                       free(token);
> +                                       for (int i = 0; i < 2; i++) {
> +                                               if (read_expected_item(TEP_EVENT_DELIM, "(") < 0) {
> +                                                       goto fail_expect;
> +                                               }
> +                                       }
> +                                       for (int brackets = 2; brackets > 0;) {
> +                                               if (read_token(&token) == TEP_EVENT_NONE) {
> +                                                       do_warning_event(event, "%s: __attribute__ not full", __func__);
> +                                                       goto fail_expect;
> +                                               }
> +                                               if (strcmp(token, "(") == 0)
> +                                                       brackets++;
> +                                               else if (strcmp(token, ")") == 0)
> +                                                       brackets--;
> +                                               free(token);
> +                                       }
> +                                       continue;
> +                               }
> +
>                                 if (strcmp(token, "*") == 0)
>                                         field->flags |= TEP_FIELD_IS_POINTER;
>
> --
> 2.24.1
>


-- 
-- Ivan
