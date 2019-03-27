Return-Path: <SRS0=8Y6V=R6=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 381ABC43381
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Mar 2019 22:54:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ECB3520811
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Mar 2019 22:54:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CP4W/IAf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727436AbfC0WyM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 27 Mar 2019 18:54:12 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:44879 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbfC0WyM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 27 Mar 2019 18:54:12 -0400
Received: by mail-io1-f65.google.com with SMTP id u12so15559021iop.11
        for <linux-trace-devel@vger.kernel.org>; Wed, 27 Mar 2019 15:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iYJViHbqMVPK7Jh1Xf6+WGNmmd+V1PQ44q0lAio226Q=;
        b=CP4W/IAfxVZIyJbGV0UdbsZBAmNc30pwkdILVgFGLWBeyTDrwaf3nV5lBS9fDHskOH
         Cs4x40Vy1+fnghT6NH6QQENdJ22OrHU5a6XQP6maLOlO3cJo+jUQOVtp6+EHpZzcLBXN
         b7wAgcUJt/LZ2SFpJZoOoROq3lykehI5O+5V0TiTorNWpUHU+VjkqjYW/Lzjed0TmdUB
         k1/kqfLNqtB7yAMFquhPm8m15CnKYTmYF/fIek75trc/0eEilniyoxVD7YCd5XkdUlNl
         yH4zlcKOZ5L95xYgsah4KuDwOxugv0kMB79vLeDFgJKHWWYhd+1kAsrffhJCiNnG19eb
         ExjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iYJViHbqMVPK7Jh1Xf6+WGNmmd+V1PQ44q0lAio226Q=;
        b=c9Cf+8Y3OcFDZfqoz9B9f7zk+CWPlzyiR7WA43uDMfJnwW8ATPLy5jqMhSJwB+WDZ/
         4cFZgprzxPv2hQJ/xbgOo+dN8nNUnL2yfx9HuaBTH8hmk3jgFN1lbKzC8oB7EtjC2E6n
         MpVesVFPfDqYE/8g2O6RCFNUuI++CUmOih6TKx+jsOIfbng+eyhIVi+9GtAUa82qW6sK
         AmN1lIfMaOMOQ5rpHV1nR9DiVHQtTYGBg0oCOm/4y4CQpLHCdSF/s2UijkoIpqXsihKC
         fXgIbHBs0j9x2eoMFje7NETXvIY+Wgc4WI3yU6W5vGC9jdmzVY1QDcLPyO8B+bUG1ln1
         KFbw==
X-Gm-Message-State: APjAAAXjnIzlcNndZMJaDHV9axns8ECE+CpGGLnuIglyzssij0ut9Vqq
        1zjWfbxT7ztzaHr1qkfouQDJpZlbqMm13G3vug==
X-Google-Smtp-Source: APXvYqwAbPfMIps6ENJUKPjCksLcmvgx4Gy641a2GXtDx7T6mO5qQnuOdXlQAjuECWzKIyofvCa7W/Sgw0ZYGNxO8U4=
X-Received: by 2002:a6b:d307:: with SMTP id s7mr26896988iob.81.1553727250855;
 Wed, 27 Mar 2019 15:54:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190327160323.31654-1-ykaradzhov@vmware.com> <20190327160323.31654-5-ykaradzhov@vmware.com>
In-Reply-To: <20190327160323.31654-5-ykaradzhov@vmware.com>
From:   Slavomir Kaslev <slavomir.kaslev@gmail.com>
Date:   Thu, 28 Mar 2019 00:53:59 +0200
Message-ID: <CAE0o1Nso6ODRjJ0e-rcLPAOPe-pue0y9=qgsysLMBCknB-ZvJg@mail.gmail.com>
Subject: Re: [RFC 4/7] kernel-shark: Add the core components of the NumPy API
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Mar 27, 2019 at 6:04 PM Yordan Karadzhov <ykaradzhov@vmware.com> wrote:
>
> The NumPy API is meant to operate on top of the C API-s of trace-cmd and
> KernelShark and to provide only the minimum of basic functionalities needed
> in order to processor the tracing data. The NumPy API itself is made of two
> layers. A bottom-one written in C and a top-one which implements the
> interface, written in Cython (C-Python). This patch introduces the C layer.

Why is there a need for two layers? Since the upper layer is Cython,
it can access the libkernelshark C API just fine. I don't understand
the need for this middle layer.

Also there's already a Python binding for traceevent, maybe we can
utilize it for this instead of providing an ad hoc binding for trace
events here too?

On an unrelated note, Python 2 will be hitting its end of life date in
a couple of months[1]. Does it make sense to start with Python 2 in
2019 when we'll need to port it to Python 3 in the very near future? I
think going for Python 3 only might be a better choice.

[1] https://pythonclock.org/

Several non high-level comments follow inline.

>
> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
> ---
>  kernel-shark/src/libkshark-py.c | 176 ++++++++++++++++++++++++++++++++
>  1 file changed, 176 insertions(+)
>  create mode 100644 kernel-shark/src/libkshark-py.c
>
> diff --git a/kernel-shark/src/libkshark-py.c b/kernel-shark/src/libkshark-py.c
> new file mode 100644
> index 0000000..4c589f3
> --- /dev/null
> +++ b/kernel-shark/src/libkshark-py.c
> @@ -0,0 +1,176 @@
> +// SPDX-License-Identifier: LGPL-2.1
> +
> +/*
> + * Copyright (C) 2019 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
> + */
> +
> + /**
> + *  @file    libpykshark-py.c

                      ^ libkshark-py.c?

> + *  @brief   Python API for processing of FTRACE (trace-cmd) data.
> + */
> +
> +// KernelShark
> +#include "libkshark.h"
> +#include "libkshark-model.h"
> +
> +bool kspy_open(const char *fname)
> +{
> +       struct kshark_context *kshark_ctx = NULL;
> +
> +       if (!kshark_instance(&kshark_ctx))
> +               return false;
> +
> +       return kshark_open(kshark_ctx, fname);
> +}
> +
> +void kspy_close(void)
> +{
> +       struct kshark_context *kshark_ctx = NULL;
> +
> +       if (!kshark_instance(&kshark_ctx))
> +               return;
> +
> +       kshark_close(kshark_ctx);
> +       kshark_free(kshark_ctx);
> +}
> +
> +static int compare(const void * a, const void * b)
> +{
> +  return ( *(int*)a - *(int*)b );
> +}
> +
> +size_t kspy_get_tasks(int **pids, char ***names)
> +{
> +       struct kshark_context *kshark_ctx = NULL;
> +       const char *comm;
> +       ssize_t i, n;
> +       int ret;
> +
> +       if (!kshark_instance(&kshark_ctx))
> +               return 0;
> +
> +       n = kshark_get_task_pids(kshark_ctx, pids);
> +       if (n == 0)
> +               return 0;
> +
> +       qsort(*pids, n, sizeof(**pids), compare);
> +
> +       *names = calloc(n, sizeof(char*));
> +       if (!(*names))
> +               goto fail;
> +
> +       for (i = 0; i < n; ++i) {
> +               comm = tep_data_comm_from_pid(kshark_ctx->pevent, (*pids)[i]);
> +               ret = asprintf(&(*names)[i], "%s", comm);
> +               if (ret < 1)
> +                       goto fail;
> +       }
> +
> +       return n;
> +
> +  fail:
> +       free(*pids);
> +       free(*names);
> +       return 0;
> +}
> +
> +size_t kspy_trace2matrix(uint64_t **offset_array,
> +                        uint8_t **cpu_array,
> +                        uint64_t **ts_array,
> +                        uint16_t **pid_array,
> +                        int **event_array)
> +{
> +       struct kshark_context *kshark_ctx = NULL;
> +       size_t total = 0;
> +
> +       if (!kshark_instance(&kshark_ctx))
> +               return false;
> +
> +       total = kshark_load_data_matrix(kshark_ctx, offset_array,
> +                                       cpu_array,
> +                                       ts_array,
> +                                       pid_array,
> +                                       event_array);
> +
> +       return total;
> +}
> +
> +int kspy_get_event_id(const char *sys, const char *evt)
> +{
> +       struct kshark_context *kshark_ctx = NULL;
> +       struct tep_event *event;
> +
> +       if (!kshark_instance(&kshark_ctx))
> +               return -1;
> +
> +       event = tep_find_event_by_name(kshark_ctx->pevent, sys, evt);
> +
> +       return event->id;
> +}
> +
> +uint64_t kspy_read_event_field(uint64_t offset, const char *sys,
> +                                               const char *evt,
> +                                               const char *field)
> +{
> +       struct kshark_context *kshark_ctx = NULL;
> +       struct tep_format_field *evt_field;
> +       struct tep_record *record;
> +       struct tep_event *event;
> +       unsigned long long val;
> +       int ret;
> +
> +       if (!kshark_instance(&kshark_ctx))
> +               return 0;
> +
> +       event = tep_find_event_by_name(kshark_ctx->pevent, sys, evt);

tep_find_event_by_name() is linear in the number of events and it does
a couple of thousand string comparisons. So calling
kspy_read_event_field() in a loop can get *really* slow. I haven't
measured, but I would guess that a good chunk of the running time of
the script in patch 7 is spent in this function.

We might want to provide an efficient API using event ids instead and
use tep_find_event() (which does binary search; that is 10s of
numerical comparisons) here to prevent Python users shooting
themselves in the foot performance-wise.

> +       if (!event)
> +               return 0;
> +
> +       evt_field = tep_find_any_field(event, field);
> +       if (!evt_field)
> +               return 0;
> +
> +       record = tracecmd_read_at(kshark_ctx->handle, offset, NULL);
> +       if (!record)
> +               return 0;
> +
> +       ret = tep_read_number_field(evt_field, record->data, &val);
> +       free_record(record);
> +
> +       if (ret != 0)
> +               return 0;
> +
> +       return val;
> +}
> +
> +void kspy_new_session_file(const char *data_file, const char *session_file)
> +{
> +       struct kshark_context *kshark_ctx = NULL;
> +       struct kshark_trace_histo histo;
> +       struct kshark_config_doc *session;
> +       struct kshark_config_doc *filters;
> +       struct kshark_config_doc *markers;
> +       struct kshark_config_doc *model;
> +       struct kshark_config_doc *file;
> +
> +       if (!kshark_instance(&kshark_ctx))
> +               return;
> +
> +       session = kshark_config_new("kshark.config.session",
> +                                   KS_CONFIG_JSON);
> +
> +       file = kshark_export_trace_file(data_file, KS_CONFIG_JSON);
> +       kshark_config_doc_add(session, "Data", file);
> +
> +       filters = kshark_export_all_filters(kshark_ctx, KS_CONFIG_JSON);
> +       kshark_config_doc_add(session, "Filters", filters);
> +
> +       ksmodel_init(&histo);
> +       model = kshark_export_model(&histo, KS_CONFIG_JSON);
> +       kshark_config_doc_add(session, "Model", model);
> +
> +       markers = kshark_config_new("kshark.config.markers", KS_CONFIG_JSON);
> +       kshark_config_doc_add(session, "Markers", markers);
> +
> +       kshark_save_config_file(session_file, session);
> +}

Aren't the struct kshark_config_doc variables leaking from this function?

Also, this function doesn't seem related to the Python bindings at
all. If it's useful on it's own, you might want to have it in
libkernelshark.
The Python binding layer should not contain any additional logic
besides defining the binding itself imo.

-- Slavi
