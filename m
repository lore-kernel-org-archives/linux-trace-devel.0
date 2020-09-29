Return-Path: <SRS0=wnl5=DG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09A9CC4727C
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Sep 2020 13:41:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A40E5216C4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Sep 2020 13:41:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gwUF1qir"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730018AbgI2Nl6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 29 Sep 2020 09:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729038AbgI2Nl4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 29 Sep 2020 09:41:56 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD5ECC0613D0
        for <linux-trace-devel@vger.kernel.org>; Tue, 29 Sep 2020 06:41:55 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id x14so5431508wrl.12
        for <linux-trace-devel@vger.kernel.org>; Tue, 29 Sep 2020 06:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dFVzAE8wcfKD+CemD60qQ3zugYabsYTZpdi+KkjpEFc=;
        b=gwUF1qirtV8VYOFFIsGatb+4YzXVu5FIf8b+Ht5kOVkKRVroopZG3/xClS920HSwSH
         7YMMmsemwaL0TOYn8mU5pMOFpMjqWtK6/5Dh2FPxFT8O7KIFfwPXm7shzkE6Kci+s6bs
         Yga1yRsl/WqMAMqzO05UkrtVIAFqfAbnu3suvbo2kbwdGSySeDBd8olKQgA0+4ZfZPX3
         KFNxxVHtnBFJ8I65uqKcWfOt70PjxMPvTXdZvLl1fToEtkkO2J7JDprFBvmGeaYAfAfG
         99NZD2cUd9fu0t8VDSMTBYvvqGxzXnC6r/ubdDPJDzhBJheSIWTLcxt1mOIHD1fyHDf0
         qWag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dFVzAE8wcfKD+CemD60qQ3zugYabsYTZpdi+KkjpEFc=;
        b=ZDAeFeXAnDzQKc9/ktGjb4cN+6C6cvJQjsB0g9E1P//H0f4WAx2xNw40uytqYakKlf
         +QsGgp5wN1kwMqHLnFHyd16W+/EclvBofxgYYm6Q9S4qVTLFovWHFQEYmxRafyWoJ8FX
         avcjY9vkgs7y+U7T9mdTDetN/JF5+8cSzMEYdSgXbAJFvafHeypGeIWclMYDz0WZAuTU
         PKidlyjR/xrEfnrF6eVEmyL5K4qS0AmphYiOVbwcxbfgTGUCzJ92eTTTXGBkO641Oo5O
         JqHoYj2hvv3rBUZjWM4vz10FsUB54YtpaBwrfQKEgnuDpbiYSkFnTSkERFGvktDJKpny
         dORQ==
X-Gm-Message-State: AOAM531Zy4Sh+pQtoEPm52F/AEwT0xrSQG/dn0y0NOXtwHvECLGwxAN7
        OcKGLhD9uPpOiHLVSL3Dqo2t/tSlPDg=
X-Google-Smtp-Source: ABdhPJw6MW1lW5zvRjl6HSLr1BgBKTm2R3WGLVaX2hSq4j6QdQXHpGIh7LVeLheog/3SppAPApIYyg==
X-Received: by 2002:adf:dccd:: with SMTP id x13mr4755292wrm.403.1601386914226;
        Tue, 29 Sep 2020 06:41:54 -0700 (PDT)
Received: from localhost.localdomain ([84.40.93.108])
        by smtp.gmail.com with ESMTPSA id b84sm6162792wmd.0.2020.09.29.06.41.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 06:41:53 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 06/15] kernel-shark: Introduce Data streams
Date:   Tue, 29 Sep 2020 16:41:14 +0300
Message-Id: <20200929134123.178688-7-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929134123.178688-1-y.karadz@gmail.com>
References: <20200929134123.178688-1-y.karadz@gmail.com>
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
 src/libkshark.h | 232 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 232 insertions(+)

diff --git a/src/libkshark.h b/src/libkshark.h
index 57bd5e5..b57fb5d 100644
--- a/src/libkshark.h
+++ b/src/libkshark.h
@@ -119,6 +119,238 @@ void kshark_hash_id_free(struct kshark_hash_id *hash);
 
 int *kshark_hash_ids(struct kshark_hash_id *hash);
 
+/**
+ * Timestamp calibration function type. To be user for system clock
+ * calibration.
+ */
+typedef void (*time_calib_func) (int64_t *, int64_t *);
+
+struct kshark_data_stream;
+
+/** A function type to be used to initialize the interface of the data stream. */
+typedef int (*interface_init_func) (struct kshark_data_stream *,
+				    const char *);
+
+/** A function type to be used to initialize the interface of the data stream. */
+typedef int (*interface_close_func) (struct kshark_data_stream *,
+				     const char *);
+
+/** A function type to be used by the method interface of the data stream. */
+typedef char *(*stream_get_str_func) (struct kshark_data_stream *,
+				      const struct kshark_entry *);
+
+/** A function type to be used by the method interface of the data stream. */
+typedef char *(*stream_get_c_str_func) (struct kshark_data_stream *,
+					const struct kshark_entry *);
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
+	KS_INVALIDE_FIELD,
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
+				     int16_t **cpu_array,
+				     int32_t **pid_array,
+				     int32_t **event_array,
+				     int64_t **offset_array,
+				     int64_t **ts_array);
+
+/** Data format identifier. */
+typedef enum kshark_data_format {
+	/** A data of unknown type. */
+	KS_INVALIDE_DATA,
+
+	/** Ftrace data. */
+	KS_TEP_DATA,
+
+	/** VMware SchedTrace data. */
+	KS_VMW_ST_DATA,
+} kshark_data_format;
+
+/**
+ * Structure representing the interface of methods used to operate over
+ * the data from a given stream.
+ */
+struct kshark_data_stream_interface {
+	/** Method used to retrieve the Process Id of the entry. */
+	stream_get_int_func	get_pid;
+
+	/** Method used to retrieve the Event Id of the entry. */
+	stream_get_int_func	get_event_id;
+
+	/** Method used to retrieve the Event name of the entry. */
+	stream_get_c_str_func	get_event_name;
+
+	/** Method used to retrieve the Task name of the entry. */
+	stream_get_c_str_func	get_task;
+
+	/** Method used to retrieve the Latency of the entry. */
+	stream_get_c_str_func	get_latency;
+
+	/** Method used to retrieve the Info string of the entry. */
+	stream_get_c_str_func	get_info;
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
+	stream_get_names_func	get_all_field_names;
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
+/** Structure representing a stream of trace data. */
+struct kshark_data_stream {
+	/** Data stream identifier. */
+	uint8_t			stream_id;
+
+	/** The number of CPUs presented in this data stream. */
+	int			n_cpus;
+
+	/**
+	 * The number of distinct event types presented in this data stream.
+	 */
+	int 			n_events;
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
+	/** System clock calibration function. */
+	time_calib_func		calib;
+
+	/** An array of time calibration constants. */
+	int64_t			*calib_array;
+
+	/** The size of the array of time calibration constants. */
+	size_t			calib_array_size;
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
+	/** List of Plugin interfaces. */
+	struct kshark_dpi_list	*plugins;
+
+	/** The number of plugins registered for this stream.*/
+	int			n_plugins;
+
+	/** The type of the data. */
+	enum kshark_data_format		format;
+
+	/** List of Plugin's Event handlers. */
+	struct kshark_event_proc_handler	*event_handlers;
+
+	/** List of Plugin's Draw handlers. */
+	struct kshark_draw_handler		*draw_handlers;
+
+	/**
+	 * The interface of methods used to operate over the data from a given
+	 * stream.
+	 */
+	struct kshark_data_stream_interface	interface;
+};
+
 /** Size of the task's hash table. */
 #define KS_TASK_HASH_SHIFT 16
 #define KS_TASK_HASH_SIZE (1 << KS_TASK_HASH_SHIFT)
-- 
2.25.1

