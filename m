Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD772C2D0E4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 20:50:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5851421D91
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 20:50:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726844AbgKLUuz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Nov 2020 15:50:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:60096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727126AbgKLUuz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Nov 2020 15:50:55 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8367321D7F;
        Thu, 12 Nov 2020 20:50:53 +0000 (UTC)
Date:   Thu, 12 Nov 2020 15:50:51 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 04/20] kernel-shark: Introduce Data streams
Message-ID: <20201112155051.18e226e9@gandalf.local.home>
In-Reply-To: <20201112142358.36821-5-y.karadz@gmail.com>
References: <20201112142358.36821-1-y.karadz@gmail.com>
        <20201112142358.36821-5-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 12 Nov 2020 16:23:42 +0200
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> With the help of Data stream, KernelShark will be able to load and
> merge multiple trace files (streams). Each stream can have different
> plugins or filters, registered for it, which means that the raw trace
> data of the streams can have different formats, and will allow for a
> great degree of customization of the provided data visualization. In
> this patch we only provide the basic definitions. The actual integration
> of the Data streams into the C API of KernelShark will happen in the
> following patches.
> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  src/libkshark.h | 216 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 216 insertions(+)
> 
> diff --git a/src/libkshark.h b/src/libkshark.h
> index cc20077f..c8fdd266 100644
> --- a/src/libkshark.h
> +++ b/src/libkshark.h
> @@ -121,6 +121,222 @@ void kshark_hash_id_free(struct kshark_hash_id *hash);
>  
>  int *kshark_hash_ids(struct kshark_hash_id *hash);
>  
> +struct kshark_data_stream;
> +
> +/** A function type to be used to initialize the interface of the data stream. */
> +typedef int (*interface_init_func) (struct kshark_data_stream *,
> +				    const char *);
> +
> +/** A function type to be used to initialize the interface of the data stream. */
> +typedef int (*interface_close_func) (struct kshark_data_stream *,
> +				     const char *);

These two typedefs should probably be introduced when a patch that uses them
is added. Otherwise they are basically meaningless for the reviewer.

Also, it the above looks like a cut-and-paste error as the close has the
same description as the init.

I don't even see the above used in later patches :-/


> +
> +/** A function type to be used by the method interface of the data stream. */
> +typedef char *(*stream_get_str_func) (struct kshark_data_stream *,
> +				      const struct kshark_entry *);
> +
> +/** A function type to be used by the method interface of the data stream. */
> +typedef const int (*stream_get_int_func) (struct kshark_data_stream *,
> +					  const struct kshark_entry *);
> +
> +/** A function type to be used by the method interface of the data stream. */
> +typedef int (*stream_find_id_func) (struct kshark_data_stream *,
> +				    const char *);
> +
> +/** A function type to be used by the method interface of the data stream. */
> +typedef int *(*stream_get_ids_func) (struct kshark_data_stream *);
> +
> +/** A function type to be used by the method interface of the data stream. */
> +typedef int (*stream_get_names_func) (struct kshark_data_stream *,
> +				      const struct kshark_entry *,
> +				      char ***);
> +
> +/** Event field format identifier. */
> +typedef enum kshark_event_field_format {
> +	/** A field of unknown type. */
> +	KS_INVALIDE_FIELD,

	KS_INVALID_FIELD ?

> +
> +	/** Integer number */
> +	KS_INTEGER_FIELD,
> +
> +	/** Floating-point number */
> +	KS_FLOAT_FIELD
> +} kshark_event_field_format;
> +
> +/** A function type to be used by the method interface of the data stream. */
> +typedef kshark_event_field_format
> +(*stream_event_field_type) (struct kshark_data_stream *,
> +			    const struct kshark_entry *,
> +			    const char *);
> +
> +/** A function type to be used by the method interface of the data stream. */
> +typedef const int (*stream_read_event_field) (struct kshark_data_stream *,
> +					      const struct kshark_entry *,
> +					      const char *,
> +					      int64_t *);
> +
> +/** A function type to be used by the method interface of the data stream. */
> +typedef const int (*stream_read_record_field) (struct kshark_data_stream *,
> +					       void *,
> +					       const char *,
> +					       int64_t *);
> +
> +struct kshark_context;
> +
> +/** A function type to be used by the method interface of the data stream. */
> +typedef ssize_t (*load_entries_func) (struct kshark_data_stream *,
> +				      struct kshark_context *,
> +				      struct kshark_entry ***);
> +
> +/** A function type to be used by the method interface of the data stream. */
> +typedef ssize_t (*load_matrix_func) (struct kshark_data_stream *,
> +				     struct kshark_context *,
> +				     int16_t **event_array,
> +				     int16_t **cpu_array,
> +				     int32_t **pid_array,
> +				     int64_t **offset_array,
> +				     int64_t **ts_array);
> +
> +/** Data format identifier. */
> +typedef enum kshark_data_format {
> +	/** A data of unknown type. */
> +	KS_INVALIDE_DATA,

	KS_INVALID_DATA ?

> +
> +	/** Ftrace data. */
> +	KS_TEP_DATA,
> +
> +	/** VMware SchedTrace data. */
> +	KS_VMW_ST_DATA,
> +} kshark_data_format;

I wonder if this should be a string value that gets registered? Otherwise
we will have to be the registry of every new stream format added.

This is the approach that Tzvetomir took for protocol ids, because that way
we don't need to keep track of them:

 https://lore.kernel.org/r/20201029111816.247241-2-tz.stoyanov@gmail.com

-- Steve

> +
> +/** Data interface identifier. */
> +typedef enum kshark_data_interface_id {
> +	/** An interface with unknown type. */
> +	KS_INVALIDE_INTERFACE,
> +
> +	/** Generic interface suitable for Ftrace data. */
> +	KS_GENERIC_DATA_INTERFACE,
> +} kshark_data_interface_id;
> +
