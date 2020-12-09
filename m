Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E039C433FE
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 13:43:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F190205F4
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 13:43:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732495AbgLINnB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Dec 2020 08:43:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732435AbgLINnB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 08:43:01 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2188C06179C
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Dec 2020 05:42:20 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id a3so1716503wmb.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 09 Dec 2020 05:42:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wOx613aSKDpx0X4AETU2Hg1vVtj/o4ph9w0WDm7FBzA=;
        b=KtxtNe77VDMqtQpASsl/AA+eYVqVeMpRAIDF3y9uvaRaNjMdi08q1wf/tP/+AWw0ql
         IoC5imZuocxEh3oqIEZjUjyN8+BgztBEi6HevQLGfR4nYSt+WuM/D7NnqqA8xEDAhMKe
         3CF9H/aBKaMrPK5Hyk4+xmOORphC/HjI2HEmpVaqXlIFbnzXG337NBcUEUe4Dz26hAkb
         5EOTXCEe5JgFP8Y8LvA6gSfhgaht8RNytCDz9R14KVvvploEvnFlZhTGidBCrnm/ROBu
         3xJBPf3exfgPcLsXO/lOJUHD2zksQpTckRD+VK0YlDo+ovNAoL3vczaCR7lkFU4Z6jjM
         +EOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wOx613aSKDpx0X4AETU2Hg1vVtj/o4ph9w0WDm7FBzA=;
        b=XF4rnyrQtAhbbgUOqIdUrS2Ydp7e7SrHP+4eCY8LO7B5dyk6n+Tbr4eHOZ4VE2Lkcc
         oec0E7PdwQfH4pAhoJJ2ugCD+bUSIfYsqAzmRmlOX+U6K35EA7pW5lp5f+vz5+Sp0OOJ
         o10jlGrSLKvlXuYnNDPXuLXNIsTWG5YD3hgWrdU4FNZ+lRfVPHuTuPSrPFRSVinrBhEG
         w1027LMaZaKn8tX/8z/E3UqAKd30rrW/dKB9xebs6GSpR50AeTQzgKp1zNj8RANdu/lS
         I9RxorePeiYnV4ztrx23hsUKLoc8KA+Yc7DjjYw3vDkhpq4w0qDPVRUEudMjLNLuk4TR
         lpAg==
X-Gm-Message-State: AOAM530t8lEduZlQqcLDNhTI/LTOAFKwqoCIUj57Vuxn94kB9WYwMShH
        3xTzcBo+qyFM11PLuG7ZFyg=
X-Google-Smtp-Source: ABdhPJwPX39gc/wpbIWhwPZXcJPP/cVYPqHmwgu6FfQC/86wg5YiWFMopybLsoRj+pGErPDzIQlIUg==
X-Received: by 2002:a1c:4b10:: with SMTP id y16mr2935404wma.73.1607521339677;
        Wed, 09 Dec 2020 05:42:19 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.104])
        by smtp.gmail.com with ESMTPSA id q143sm3871071wme.28.2020.12.09.05.42.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 05:42:19 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v6 04/27] kernel-shark: Introduce Data streams
Date:   Wed,  9 Dec 2020 15:41:40 +0200
Message-Id: <20201209134203.428068-5-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201209134203.428068-1-y.karadz@gmail.com>
References: <20201209134203.428068-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

With the help of Data stream, KernelShark will be able to load and
merge multiple trace files (streams). Each stream can have different
plugins or filters, registered for it, which means that the raw trace
data of the streams can have different formats, and will allow for a
great degree of customization of the provided data visualization. In
this patch we only provide the basic definitions. The actual integration
of the Data streams into the C API of KernelShark will happen in the
following patches.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/libkshark.h | 199 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 199 insertions(+)

diff --git a/src/libkshark.h b/src/libkshark.h
index cc20077..9f7b6b1 100644
--- a/src/libkshark.h
+++ b/src/libkshark.h
@@ -121,6 +121,205 @@ void kshark_hash_id_free(struct kshark_hash_id *hash);
 
 int *kshark_hash_ids(struct kshark_hash_id *hash);
 
+struct kshark_data_stream;
+
+/** A function type to be used by the method interface of the data stream. */
+typedef char *(*stream_get_str_func) (struct kshark_data_stream *,
+				      const struct kshark_entry *);
+
+/** A function type to be used by the method interface of the data stream. */
+typedef const int (*stream_get_int_func) (struct kshark_data_stream *,
+					  const struct kshark_entry *);
+
+/** A function type to be used by the method interface of the data stream. */
+typedef int (*stream_find_id_func) (struct kshark_data_stream *,
+				    const char *);
+
+/** A function type to be used by the method interface of the data stream. */
+typedef int *(*stream_get_ids_func) (struct kshark_data_stream *);
+
+/** A function type to be used by the method interface of the data stream. */
+typedef int (*stream_get_names_func) (struct kshark_data_stream *,
+				      const struct kshark_entry *,
+				      char ***);
+
+/** Event field format identifier. */
+typedef enum kshark_event_field_format {
+	/** A field of unknown type. */
+	KS_INVALID_FIELD,
+
+	/** Integer number */
+	KS_INTEGER_FIELD,
+
+	/** Floating-point number */
+	KS_FLOAT_FIELD
+} kshark_event_field_format;
+
+/** A function type to be used by the method interface of the data stream. */
+typedef kshark_event_field_format
+(*stream_event_field_type) (struct kshark_data_stream *,
+			    const struct kshark_entry *,
+			    const char *);
+
+/** A function type to be used by the method interface of the data stream. */
+typedef const int (*stream_read_event_field) (struct kshark_data_stream *,
+					      const struct kshark_entry *,
+					      const char *,
+					      int64_t *);
+
+/** A function type to be used by the method interface of the data stream. */
+typedef const int (*stream_read_record_field) (struct kshark_data_stream *,
+					       void *,
+					       const char *,
+					       int64_t *);
+
+struct kshark_context;
+
+/** A function type to be used by the method interface of the data stream. */
+typedef ssize_t (*load_entries_func) (struct kshark_data_stream *,
+				      struct kshark_context *,
+				      struct kshark_entry ***);
+
+/** A function type to be used by the method interface of the data stream. */
+typedef ssize_t (*load_matrix_func) (struct kshark_data_stream *,
+				     struct kshark_context *,
+				     int16_t **event_array,
+				     int16_t **cpu_array,
+				     int32_t **pid_array,
+				     int64_t **offset_array,
+				     int64_t **ts_array);
+
+/** Data interface identifier. */
+typedef enum kshark_data_interface_id {
+	/** An interface with unknown type. */
+	KS_INVALID_INTERFACE,
+
+	/** Generic interface suitable for Ftrace data. */
+	KS_GENERIC_DATA_INTERFACE,
+} kshark_data_interface_id;
+
+/**
+ * Structure representing the interface of methods used to operate over
+ * the data from a given stream.
+ */
+struct kshark_generic_stream_interface {
+	/** Interface version identifier. */
+	kshark_data_interface_id	type; /* MUST BE FIRST ENTRY. */
+
+	/** Method used to retrieve the Process Id of the entry. */
+	stream_get_int_func	get_pid;
+
+	/** Method used to retrieve the Event Id of the entry. */
+	stream_get_int_func	get_event_id;
+
+	/** Method used to retrieve the Event name of the entry. */
+	stream_get_str_func	get_event_name;
+
+	/** Method used to retrieve the Task name of the entry. */
+	stream_get_str_func	get_task;
+
+	/** Method used to retrieve the Info string of the entry. */
+	stream_get_str_func	get_info;
+
+	/**
+	 * Method used to retrieve an unspecified auxiliary info of the trace
+	 * record.
+	 */
+	stream_get_str_func	aux_info;
+
+	/** Method used to retrieve Id of the Event from its name. */
+	stream_find_id_func	find_event_id;
+
+	/** Method used to retrieve the array of Ids of all Events. */
+	stream_get_ids_func	get_all_event_ids;
+
+	/** Method used to dump the entry's content to string. */
+	stream_get_str_func	dump_entry;
+
+	/**
+	 * Method used to retrieve the array of all field names of a given
+	 * event.
+	 */
+	stream_get_names_func	get_all_event_field_names;
+
+	/** Method used to access the type of an event's data field. */
+	stream_event_field_type		get_event_field_type;
+
+	/** Method used to access the value of an event's data field. */
+	stream_read_event_field		read_event_field_int64;
+
+	/** Method used to access the value of an event's data field. */
+	stream_read_record_field	read_record_field_int64;
+
+	/** Method used to load the data in the form of entries. */
+	load_entries_func	load_entries;
+
+	/** Method used to load the data in matrix form. */
+	load_matrix_func	load_matrix;
+
+	/** Generic data handle. */
+	void			*handle;
+};
+
+/** The limit in size of the data format identifier string. */
+#define KS_DATA_FORMAT_SIZE	15
+
+/** Structure representing a stream of trace data. */
+struct kshark_data_stream {
+	/** Data stream identifier. */
+	uint16_t		stream_id;
+
+	/** The number of CPUs presented in this data stream. */
+	int			n_cpus;
+
+	/**
+	 * The number of distinct event types presented in this data stream.
+	 */
+	int			n_events;
+
+	/** The Process Id of the Idle task. */
+	int			idle_pid;
+
+	/** Trace data file pathname. */
+	char			*file;
+
+	/** Stream name. */
+	char			*name;
+
+	/** Hash table of task PIDs. */
+	struct kshark_hash_id	*tasks;
+
+	/** A mutex, used to protect the access to the input file. */
+	pthread_mutex_t		input_mutex;
+
+	/** Hash of tasks to filter on. */
+	struct kshark_hash_id	*show_task_filter;
+
+	/** Hash of tasks to not display. */
+	struct kshark_hash_id	*hide_task_filter;
+
+	/** Hash of events to filter on. */
+	struct kshark_hash_id	*show_event_filter;
+
+	/** Hash of events to not display. */
+	struct kshark_hash_id	*hide_event_filter;
+
+	/** Hash of CPUs to filter on. */
+	struct kshark_hash_id	*show_cpu_filter;
+
+	/** Hash of CPUs to not display. */
+	struct kshark_hash_id	*hide_cpu_filter;
+
+	/** The type of the data. */
+	char			data_format[KS_DATA_FORMAT_SIZE];
+
+	/**
+	 * The interface of methods used to operate over the data from a given
+	 * stream.
+	 */
+	void				*interface;
+};
+
 /** Size of the task's hash table. */
 #define KS_TASK_HASH_SHIFT 16
 #define KS_TASK_HASH_SIZE (1 << KS_TASK_HASH_SHIFT)
-- 
2.25.1

