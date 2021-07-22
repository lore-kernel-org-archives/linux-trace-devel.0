Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDC1CC63799
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Jul 2021 13:36:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0AA96135F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Jul 2021 13:36:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232133AbhGVM4Q (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Jul 2021 08:56:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:46586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232160AbhGVMzo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Jul 2021 08:55:44 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6E4261289;
        Thu, 22 Jul 2021 13:36:19 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1m6Ys6-001at3-Nj; Thu, 22 Jul 2021 09:36:18 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v2 2/4] libtracefs: Create a way to create a synthetic event
Date:   Thu, 22 Jul 2021 09:36:08 -0400
Message-Id: <20210722133610.379933-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210722133610.379933-1-rostedt@goodmis.org>
References: <20210722133610.379933-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add the following APIs:

 tracefs_synth_init()
 tracefs_synth_add_match_field()
 tracefs_synth_add_compare_field()
 tracefs_synth_add_start_field()
 tracefs_synth_add_end_field()
 tracefs_synth_add_start_filter()
 tracefs_synth_add_end_filter()
 tracefs_synth_create()
 tracefs_synth_destroy()
 tracefs_synth_free()
 tracefs_synth_show()

to be able to easily create synthetic events using the histogram triggers.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/tracefs.h  |   66 +++
 src/tracefs-hist.c | 1079 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 1145 insertions(+)

diff --git a/include/tracefs.h b/include/tracefs.h
index 4dd77b9c4119..77a1a37f5b06 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -300,4 +300,70 @@ int tracefs_hist_continue(struct tracefs_hist *hist);
 int tracefs_hist_reset(struct tracefs_hist *hist);
 int tracefs_hist_destroy(struct tracefs_hist *hist);
 
+struct tracefs_synth;
+
+/*
+ * DELTA_END	- end_field - start_field
+ * DELTA_START	- start_field - end_field
+ * ADD		- start_field + end_field
+ */
+enum tracefs_synth_calc {
+	TRACEFS_SYNTH_DELTA_END,
+	TRACEFS_SYNTH_DELTA_START,
+	TRACEFS_SYNTH_ADD,
+};
+
+enum tracefs_synth_compare {
+	TRACEFS_COMPARE_EQ,
+	TRACEFS_COMPARE_NQ,
+	TRACEFS_COMPARE_GR,
+	TRACEFS_COMPARE_GE,
+	TRACEFS_COMPARE_LT,
+	TRACEFS_COMPARE_LE,
+	TRACEFS_COMPARE_RE,
+	TRACEFS_COMPARE_AND,
+};
+
+struct tracefs_synth *tracefs_synth_init(struct tep_handle *tep,
+					 const char *name,
+					 const char *start_system,
+					 const char *start_event,
+					 const char *end_system,
+					 const char *end_event,
+					 const char *start_match_field,
+					 const char *end_match_field,
+					 const char *match_name);
+int tracefs_synth_add_match_field(struct tracefs_synth *synth,
+				  const char *start_match_field,
+				  const char *end_match_field,
+				  const char *name);
+int tracefs_synth_add_compare_field(struct tracefs_synth *synth,
+				    const char *start_compare_field,
+				    const char *end_compare_field,
+				    enum tracefs_synth_calc calc,
+				    const char *name);
+int tracefs_synth_add_start_field(struct tracefs_synth *synth,
+				  const char *start_field,
+				  const char *name);
+int tracefs_synth_add_end_field(struct tracefs_synth *synth,
+				const char *end_field,
+				const char *name);
+int tracefs_synth_add_start_filter(struct tracefs_synth *synth,
+				   const char *field,
+				   enum tracefs_synth_compare compare,
+				   const char *val,
+				   bool neg, bool or);
+int tracefs_synth_add_end_filter(struct tracefs_synth *synth,
+				 const char *field,
+				 enum tracefs_synth_compare compare,
+				 const char *val,
+				 bool neg, bool or);
+int tracefs_synth_create(struct tracefs_instance *instance,
+			 struct tracefs_synth *synth);
+int tracefs_synth_destroy(struct tracefs_instance *instance,
+			  struct tracefs_synth *synth);
+void tracefs_synth_free(struct tracefs_synth *synth);
+int tracefs_synth_show(struct trace_seq *seq, struct tracefs_instance *instance,
+		       struct tracefs_synth *synth);
+
 #endif /* _TRACE_FS_H */
diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index 9031a77eba4b..5ba865d95548 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -527,3 +527,1082 @@ int tracefs_hist_sort_key_direction(struct tracefs_hist *hist,
 	sort[i] = sort_key;
 	return 0;
 }
+
+/*
+ * @name: name of the synthetic event
+ * @start_system: system of the starting event
+ * @start_event: the starting event
+ * @end_system: system of the ending event
+ * @end_event: the ending event
+ * @match_names: If a match set is to be a synthetic field, it has a name
+ * @start_match: list of keys in the start event that matches end event
+ * @end_match: list of keys in the end event that matches the start event
+ * @compare_names: The synthetic field names of the compared fields
+ * @start_compare: A list of compare fields in the start to compare to end
+ * @end_compare: A list of compare fields in the end to compare to start
+ * @compare_ops: The type of operations to perform between the start and end
+ * @start_names: The fields in the start event to record
+ * @end_names: The fields in the end event to record
+ * @start_filters: The fields in the end event to record
+ * @end_filters: The fields in the end event to record
+ */
+struct tracefs_synth {
+	struct tep_handle	*tep;
+	struct tep_event	*start_event;
+	struct tep_event	*end_event;
+	char			*name;
+	char			**synthetic_fields;
+	char			**synthetic_args;
+	char			**start_keys;
+	char			**end_keys;
+	char			**start_vars;
+	char			**end_vars;
+	char			*start_filter;
+	char			*end_filter;
+
+	int			arg_cnt;
+};
+
+void tracefs_synth_free(struct tracefs_synth *synth)
+{
+	if (!synth)
+		return;
+
+	free(synth->name);
+	tracefs_list_free(synth->synthetic_fields);
+	tracefs_list_free(synth->synthetic_args);
+	tracefs_list_free(synth->start_keys);
+	tracefs_list_free(synth->end_keys);
+	tracefs_list_free(synth->start_vars);
+	tracefs_list_free(synth->end_vars);
+	free(synth->start_filter);
+	free(synth->end_filter);
+
+	tep_unref(synth->tep);
+
+	free(synth);
+}
+
+static bool verify_event_fields(struct tep_event *start_event,
+				struct tep_event *end_event,
+				const char *start_field_name,
+				const char *end_field_name,
+				struct tep_format_field **ptr_start_field)
+{
+	struct tep_format_field *start_field;
+	struct tep_format_field *end_field;
+
+	start_field = tep_find_any_field(start_event, start_field_name);
+	if (!start_field)
+		goto nodev;
+
+	if (end_event) {
+		end_field = tep_find_any_field(end_event, end_field_name);
+		if (!start_field)
+			goto nodev;
+
+		if (start_field->flags != end_field->flags ||
+		    start_field->size != end_field->size) {
+			errno = EBADE;
+			return false;
+		}
+	}
+
+	if (ptr_start_field)
+		*ptr_start_field = start_field;
+
+	return true;
+ nodev:
+	errno = ENODEV;
+	return false;
+}
+
+static char *append_string(char *str, const char *space, const char *add)
+{
+	char *new;
+	int len;
+
+	/* String must already be allocated */
+	if (!str)
+		return NULL;
+
+	len = strlen(str) + strlen(add) + 2;
+	if (space)
+		len += strlen(space);
+
+	new = realloc(str, len);
+	if (!new) {
+		free(str);
+		return NULL;
+	}
+	str = new;
+
+	if (space)
+		strcat(str, space);
+	strcat(str, add);
+
+	return str;
+}
+
+static char *add_synth_field(struct tep_format_field *field,
+			     const char *name)
+{
+	const char *type;
+	char size[64];
+	char *str;
+	bool sign;
+
+	if (field->flags & TEP_FIELD_IS_ARRAY) {
+		str = strdup("char");
+		str = append_string(str, " ", name);
+		str = append_string(str, NULL, "[");
+
+		if (!(field->flags & TEP_FIELD_IS_DYNAMIC)) {
+			snprintf(size, 64, "%d", field->size);
+			str = append_string(str, NULL, size);
+		}
+		return append_string(str, NULL, "];");
+	}
+
+	sign = field->flags & TEP_FIELD_IS_SIGNED;
+
+	switch (field->size) {
+	case 1:
+		if (!sign)
+			type = "unsigned char";
+		else
+			type = "char";
+		break;
+	case 2:
+		if (sign)
+			type = "s16";
+		else
+			type = "u16";
+		break;
+	case 4:
+		if (sign)
+			type = "s32";
+		else
+			type = "u32";
+		break;
+	case 8:
+		if (sign)
+			type = "s64";
+		else
+			type = "u64";
+		break;
+	default:
+		errno = EBADF;
+		return NULL;
+	}
+
+	str = strdup(type);
+	str = append_string(str, " ", name);
+	return append_string(str, NULL, ";");
+}
+
+static int add_var(char ***list, const char *name, const char *var, bool is_var)
+{
+	char **new;
+	char *assign;
+	int ret;
+
+	if (is_var)
+		ret = asprintf(&assign, "%s=$%s", name, var);
+	else
+		ret = asprintf(&assign, "%s=%s", name, var);
+
+	if (ret < 0)
+		return -1;
+
+	new = tracefs_list_add(*list, assign);
+	free(assign);
+
+	if (!new)
+		return -1;
+	*list = new;
+	return 0;
+}
+
+/**
+ * tracefs_synth_init - create a new tracefs_synth instance
+ * @tep: The tep handle that holds the events to work on
+ * @name: The name of the synthetic event being created
+ * @start_system: The name of the system of the start event (can be NULL)
+ * @start_event_name: The name of the start event
+ * @end_system: The name of the system of the end event (can be NULL)
+ * @end_event_name: The name of the end event
+ * @start_match_field: The name of the field in start event to match @end_match_field
+ * @end_match_field: The name of the field in end event to match @start_match_field
+ * @match_name: Name to call the fields that match (can be NULL)
+ * 
+ * Creates a tracefs_synth instance that has the minimum requirements to
+ * create a synthetic event.
+ *
+ * @name is will be the name of the synthetic event that this can create.
+ *
+ * The start event is found with @start_system and @start_event_name. If
+ * @start_system is NULL, then the first event with @start_event_name will
+ * be used.
+ *
+ * The end event is found with @end_system and @end_event_name. If
+ * @end_system is NULL, then the first event with @end_event_name will
+ * be used.
+ *
+ * The @start_match_field is the field in the start event that will be used
+ * to match the @end_match_field of the end event.
+ *
+ * If @match_name is given, then the field that matched the start and
+ * end events will be passed an a field to the sythetic event with this
+ * as the field name.
+ *
+ * Returns an allocated tracefs_synth descriptor on success and NULL
+ * on error, with the following set in errno.
+ *
+ * ENOMEM - memory allocation failure.
+ * ENIVAL - a parameter is passed as NULL that should not be
+ * ENODEV - could not find an event or field
+ * EBADE - The start and end fields are not compatible to match 
+ * 
+ * Note, this does not modify the system. That is, the synthetic
+ * event on the system is not created. That needs to be done with
+ * tracefs_synth_create().
+ */
+struct tracefs_synth *tracefs_synth_init(struct tep_handle *tep,
+					 const char *name,
+					 const char *start_system,
+					 const char *start_event_name,
+					 const char *end_system,
+					 const char *end_event_name,
+					 const char *start_match_field,
+					 const char *end_match_field,
+					 const char *match_name)
+{
+	struct tep_event *start_event;
+	struct tep_event *end_event;
+	struct tracefs_synth *synth;
+	int ret = 0;
+
+	if (!tep || !name || !start_event_name || !end_event_name ||
+	    !start_match_field || !end_match_field) {
+		errno = EINVAL;
+		return NULL;
+	}
+
+	start_event = tep_find_event_by_name(tep, start_system,
+					     start_event_name);
+	if (!start_event) {
+		errno = ENODEV;
+		return NULL;
+	}
+
+	end_event = tep_find_event_by_name(tep, end_system,
+					   end_event_name);
+	if (!end_event) {
+		errno = ENODEV;
+		return NULL;
+	}
+
+	synth = calloc(1, sizeof(*synth));
+	if (!synth)
+		return NULL;
+
+	synth->start_event = start_event;
+	synth->end_event = end_event;
+
+	synth->name = strdup(name);
+
+	ret = tracefs_synth_add_match_field(synth, start_match_field,
+					    end_match_field, match_name);
+
+	/* Hold onto a reference to this handler */
+	tep_ref(tep);
+	synth->tep = tep;
+
+	if (!synth->name || !synth->start_keys || !synth->end_keys || ret) {
+		tracefs_synth_free(synth);
+		synth = NULL;
+	}
+
+	return synth;
+}
+
+static int add_synth_fields(struct tracefs_synth *synth,
+			    struct tep_format_field *field,
+			    const char *name)
+{
+	char **list;
+	char *str;
+	int ret;
+
+	str = add_synth_field(field, name);
+	if (!str)
+		return -1;
+
+	list = tracefs_list_add(synth->synthetic_fields, str);
+	free(str);
+	if (!list)
+		return -1;
+	synth->synthetic_fields = list;
+
+	ret = asprintf(&str, "$%s", name);
+	if (ret < 0) {
+		tracefs_list_pop(synth->synthetic_fields);
+		return -1;
+	}
+
+	list = tracefs_list_add(synth->synthetic_args, str);
+	free(str);
+	if (!list) {
+		tracefs_list_pop(synth->synthetic_fields);
+		return -1;
+	}
+
+	synth->synthetic_args = list;
+
+	return 0;
+}
+
+/**
+ * tracefs_synth_add_match_field - add another key to match events
+ * @synth: The tracefs_synth descriptor
+ * @start_match_field: The field of the start event to match the end event
+ * @end_match_field: The field of the end event to match the start event
+ * @name: The name to show in the synthetic event (NULL is allowed)
+ *
+ * This will add another set of keys to use for a match between
+ * the start event and the end event.
+ *
+ * Returns 0 on succes and -1 on error.
+ * On error, errno is set to:
+ * ENOMEM - memory allocation failure.
+ * ENIVAL - a parameter is passed as NULL that should not be
+ * ENODEV - could not find a field
+ * EBADE - The start and end fields are not compatible to match 
+ */
+int tracefs_synth_add_match_field(struct tracefs_synth *synth,
+				  const char *start_match_field,
+				  const char *end_match_field,
+				  const char *name)
+{
+	struct tep_format_field *key_field;
+	char **list;
+	int ret;
+
+	if (!synth || !start_match_field || !end_match_field) {
+		errno = EINVAL;
+		return -1;
+	}
+
+	if (!verify_event_fields(synth->start_event, synth->end_event,
+				 start_match_field, end_match_field,
+				 &key_field))
+		return -1;
+
+	list = tracefs_list_add(synth->start_keys, start_match_field);
+	if (!list)
+		return -1;
+
+	synth->start_keys = list;
+
+	list = tracefs_list_add(synth->end_keys, end_match_field);
+	if (!list) {
+		tracefs_list_pop(synth->start_keys);
+		return -1;
+	}
+	synth->end_keys = list;
+
+	if (!name)
+		return 0;
+
+	ret = add_var(&synth->end_vars, name, end_match_field, false);
+
+	if (ret < 0)
+		goto pop_lists;
+
+	ret = add_synth_fields(synth, key_field, name);
+	if (ret < 0)
+		goto pop_lists;
+
+	return 0;
+
+ pop_lists:
+	tracefs_list_pop(synth->start_keys);
+	tracefs_list_pop(synth->end_keys);
+	return -1;
+}
+
+static char *new_arg(struct tracefs_synth *synth)
+{
+	int cnt = synth->arg_cnt + 1;
+	char *arg;
+	int ret;
+
+	ret = asprintf(&arg, "__arg__%d", cnt);
+	if (ret < 0)
+		return NULL;
+
+	synth->arg_cnt = cnt;
+	return arg;
+}
+
+/**
+ * tracefs_synth_add_compare_field - add a comparison between start and end
+ * @synth: The tracefs_synth descriptor
+ * @start_compare_field: The field of the start event to compare to the end
+ * @end_compare_field: The field of the end event to compare to the start
+ * @calc - How to go about the comparing the fields.
+ * @name: The name to show in the synthetic event (must NOT be NULL)
+ *
+ * This will add a way to compare two different fields between the
+ * start end end events.
+ *
+ * The comparing between events is decided by @calc:
+ *    TRACEFS_SYNTH_DELTA_END       - name = end - start
+ *    TRACEFS_SYNTH_DELTA_START     - name = start - end
+ *    TRACEFS_SYNTH_ADD             - name = end + start
+ *
+ * Returns 0 on succes and -1 on error.
+ * On error, errno is set to:
+ * ENOMEM - memory allocation failure.
+ * ENIVAL - a parameter is passed as NULL that should not be
+ * ENODEV - could not find a field
+ * EBADE - The start and end fields are not compatible to compare
+ */
+int tracefs_synth_add_compare_field(struct tracefs_synth *synth,
+				    const char *start_compare_field,
+				    const char *end_compare_field,
+				    enum tracefs_synth_calc calc,
+				    const char *name)
+{
+	struct tep_format_field *start_field;
+	char *start_arg;
+	char *compare;
+	int ret;
+
+	/* Compare fields require a name */
+	if (!name || !start_compare_field || !end_compare_field) {
+		errno = -EINVAL;
+		return -1;
+	}
+
+	if (!verify_event_fields(synth->start_event, synth->end_event,
+				 start_compare_field, end_compare_field,
+				 &start_field))
+		return -1;
+
+	/* Calculations are not allowed on string */
+	if (start_field->flags & (TEP_FIELD_IS_ARRAY |
+				  TEP_FIELD_IS_DYNAMIC)) {
+		errno = -EINVAL;
+		return -1;
+	}
+
+	start_arg = new_arg(synth);
+	if (!start_arg)
+		return -1;
+
+	ret = add_var(&synth->start_vars, start_arg, start_compare_field, false);
+	if (ret < 0) {
+		free(start_arg);
+		return -1;
+	}
+
+	ret = -1;
+	switch (calc) {
+	case TRACEFS_SYNTH_DELTA_END:
+		ret = asprintf(&compare, "%s-$%s", end_compare_field,
+			       start_arg);
+		break;
+	case TRACEFS_SYNTH_DELTA_START:
+		ret = asprintf(&compare, "$%s-%s", start_arg,
+			       end_compare_field);
+		break;
+	case TRACEFS_SYNTH_ADD:
+		ret = asprintf(&compare, "%s+$%s", end_compare_field,
+			       start_arg);
+		break;
+	}
+	free(start_arg);
+	if (ret < 0)
+		return -1;
+
+	ret = add_var(&synth->end_vars, name, compare, false);
+	if (ret < 0)
+		goto out_free;
+
+	ret = add_synth_fields(synth, start_field, name);
+	if (ret < 0)
+		goto out_free;
+
+ out_free:
+	free(compare);
+
+	return ret ? -1 : 0;
+}
+
+/**
+ * tracefs_synth_add_start_field - add a start field to save
+ * @synth: The tracefs_synth descriptor
+ * @start_field: The field of the start event to save
+ * @name: The name to show in the synthetic event (if NULL @start_field is used)
+ *
+ * This adds a field named by @start_field of the start event to
+ * record in the synthetic event.
+ *
+ * Returns 0 on succes and -1 on error.
+ * On error, errno is set to:
+ * ENOMEM - memory allocation failure.
+ * ENIVAL - a parameter is passed as NULL that should not be
+ * ENODEV - could not find a field
+ */
+int tracefs_synth_add_start_field(struct tracefs_synth *synth,
+				  const char *start_field,
+				  const char *name)
+{
+	struct tep_format_field *field;
+	char *start_arg;
+	int ret;
+
+	if (!synth || !start_field) {
+		errno = EINVAL;
+		return -1;
+	}
+
+	if (!name)
+		name = start_field;
+
+	if (!verify_event_fields(synth->start_event, NULL,
+				 start_field, NULL, &field))
+		return -1;
+
+	start_arg = new_arg(synth);
+	if (!start_arg)
+		return -1;
+
+	ret = add_var(&synth->start_vars, start_arg, start_field, false);
+	if (ret)
+		goto out_free;
+
+	ret = add_var(&synth->end_vars, name, start_arg, true);
+	if (ret)
+		goto out_free;
+
+	ret = add_synth_fields(synth, field, name);
+
+ out_free:
+	free(start_arg);
+	return ret;
+}
+
+/**
+ * tracefs_synth_add_end_field - add a end field to save
+ * @synth: The tracefs_synth descriptor
+ * @end_field: The field of the end event to save
+ * @name: The name to show in the synthetic event (if NULL @end_field is used)
+ *
+ * This adds a field named by @end_field of the start event to
+ * record in the synthetic event.
+ *
+ * Returns 0 on succes and -1 on error.
+ * On error, errno is set to:
+ * ENOMEM - memory allocation failure.
+ * ENIVAL - a parameter is passed as NULL that should not be
+ * ENODEV - could not find a field
+ */
+int tracefs_synth_add_end_field(struct tracefs_synth *synth,
+				const char *end_field,
+				const char *name)
+{
+	struct tep_format_field *field;
+	int ret;
+
+	if (!synth || !end_field) {
+		errno = EINVAL;
+		return -1;
+	}
+
+	if (!name)
+		name = end_field;
+
+	if (!verify_event_fields(synth->end_event, NULL,
+				 end_field, NULL, &field))
+		return -1;
+
+	ret = add_var(&synth->end_vars, name, end_field, false);
+	if (ret)
+		goto out;
+
+	ret = add_synth_fields(synth, field, name);
+
+ out:
+	return ret;
+}
+
+static int add_synth_filter(char **filter, const char *field,
+			    enum tracefs_synth_compare compare,
+			    const char *val, bool is_string,
+			    bool neg, bool or)
+{
+	const char *minus = "";
+	const char *op;
+	char *str = NULL;
+	int ret;
+
+	switch (compare) {
+	case TRACEFS_COMPARE_EQ:
+		op = "==";
+		break;
+
+	case TRACEFS_COMPARE_NQ:
+		op = "!=";
+		break;
+
+	case TRACEFS_COMPARE_GR:
+		op = ">";
+		if (is_string)
+			goto inval;
+		break;
+
+	case TRACEFS_COMPARE_GE:
+		op = ">=";
+		if (is_string)
+			goto inval;
+		break;
+
+	case TRACEFS_COMPARE_LT:
+		op = "<";
+		if (is_string)
+			goto inval;
+		break;
+
+	case TRACEFS_COMPARE_LE:
+		op = "<=";
+		if (is_string)
+			goto inval;
+		break;
+
+	case TRACEFS_COMPARE_RE:
+		op = "~";
+		if (!is_string)
+			goto inval;
+		break;
+
+	case TRACEFS_COMPARE_AND:
+		op = "&";
+		if (is_string)
+			goto inval;
+		break;
+	}
+
+	if (neg)
+		minus = "-";
+
+	if (is_string && val[0] != '"')
+		ret = asprintf(&str, "%s(%s %s \"%s\")",
+			       minus, field, op, val);
+	else
+		ret = asprintf(&str, "%s(%s %s %s)",
+			       minus, field, op, val);
+
+	if (ret < 0)
+		return -1;
+
+	if (*filter) {
+		char *new;
+		char *conjunction = or ? "||" : "&&";
+
+		ret = asprintf(&new, "%s %s %s", *filter,
+			       conjunction, str);
+		free(str);
+		if (ret < 0)
+			return -1;
+		free(*filter);
+		*filter = new;
+	} else {
+		*filter = str;
+	}
+
+	return 0;
+inval:
+	errno = -EINVAL;
+	return -1;
+}
+
+int tracefs_synth_add_start_filter(struct tracefs_synth *synth,
+				   const char *field,
+				   enum tracefs_synth_compare compare,
+				   const char *val,
+				   bool neg, bool or)
+{
+	struct tep_format_field *start_field;
+	bool is_string;
+
+	if (!field || !val)
+		goto inval;
+
+	if (!verify_event_fields(synth->start_event, NULL,
+				 field, NULL, &start_field))
+		return -1;
+
+	is_string = start_field->flags & TEP_FIELD_IS_STRING;
+
+	if (!is_string && (start_field->flags & TEP_FIELD_IS_ARRAY))
+		goto inval;
+
+	return add_synth_filter(&synth->start_filter,
+				field, compare, val, is_string,
+				neg, or);
+inval:
+	errno = -EINVAL;
+	return -1;
+}
+
+int tracefs_synth_add_end_filter(struct tracefs_synth *synth,
+				 const char *field,
+				 enum tracefs_synth_compare compare,
+				 const char *val,
+				 bool neg, bool or)
+{
+	struct tep_format_field *end_field;
+	bool is_string;
+
+	if (!field || !val)
+		goto inval;
+
+	if (!verify_event_fields(synth->end_event, NULL,
+				 field, NULL, &end_field))
+		return -1;
+
+	is_string = end_field->flags & TEP_FIELD_IS_STRING;
+
+	if (!is_string && (end_field->flags & TEP_FIELD_IS_ARRAY))
+		goto inval;
+
+	return add_synth_filter(&synth->end_filter,
+				field, compare, val, is_string,
+				neg, or);
+inval:
+	errno = -EINVAL;
+	return -1;
+}
+
+static char *create_synthetic_event(struct tracefs_synth *synth)
+{
+	char *synthetic_event;
+	const char *field;
+	int i;
+
+	synthetic_event = strdup(synth->name);
+	if (!synthetic_event)
+		return NULL;
+
+	for (i = 0; synth->synthetic_fields && synth->synthetic_fields[i]; i++) {
+		field = synth->synthetic_fields[i];
+		synthetic_event = append_string(synthetic_event, " ", field);
+	}
+
+	return synthetic_event;
+}
+
+static int remove_synthetic(const char *synthetic)
+{
+	char *str;
+	int ret;
+
+	ret = asprintf(&str, "!%s", synthetic);
+	if (ret < 0)
+		return -1;
+
+	ret = tracefs_instance_file_append(NULL, "synthetic_events", str);
+	free(str);
+	return ret < 0 ? -1 : 0;
+}
+
+static int remove_hist(struct tracefs_instance *instance,
+		       struct tep_event *event, const char *hist)
+{
+	char *str;
+	int ret;
+
+	ret = asprintf(&str, "!%s", hist);
+	if (ret < 0)
+		return -1;
+
+	ret = tracefs_event_file_append(instance, event->system, event->name,
+				  "trigger", str);
+	free(str);
+	return ret < 0 ? -1 : 0;
+}
+
+static char *create_hist(char **keys, char **vars)
+{
+	char *hist = strdup("hist:keys=");
+	char *name;
+	int i;
+
+	if (!hist)
+		return NULL;
+
+	for (i = 0; keys[i]; i++) {
+		name = keys[i];
+		if (i)
+			hist = append_string(hist, NULL, ",");
+		hist = append_string(hist, NULL, name);
+	}
+
+	if (!vars)
+		return hist;
+
+	hist = append_string(hist, NULL, ":");
+
+	for (i = 0; vars[i]; i++) {
+		name = vars[i];
+		if (i)
+			hist = append_string(hist, NULL, ",");
+		hist = append_string(hist, NULL, name);
+	}
+
+	return hist;
+}
+
+static char *create_end_hist(struct tracefs_synth *synth)
+{
+	const char *name;
+	char *end_hist;
+	int i;
+
+	end_hist = create_hist(synth->end_keys, synth->end_vars);
+	end_hist = append_string(end_hist, NULL, ":onmatch(");
+	end_hist = append_string(end_hist, NULL, synth->start_event->system);
+	end_hist = append_string(end_hist, NULL, ".");
+	end_hist = append_string(end_hist, NULL, synth->start_event->name);
+	end_hist = append_string(end_hist, NULL, ").trace(");
+	end_hist = append_string(end_hist, NULL, synth->name);
+
+	for (i = 0; synth->synthetic_args && synth->synthetic_args[i]; i++) {
+		name = synth->synthetic_args[i];
+
+		end_hist = append_string(end_hist, NULL, ",");
+		end_hist = append_string(end_hist, NULL, name);
+	}
+
+	return append_string(end_hist, NULL, ")");
+}
+
+/**
+ * tracefs_synth_create - creates the synthetic event on the system
+ * @instance: The instance to modify the start and end events
+ * @synth: The tracefs_synth descriptor
+ *
+ * This creates the synthetic events. The @instance is used for writing
+ * the triggers into the start and end events.
+ *
+ * Returns 0 on succes and -1 on error.
+ * On error, errno is set to:
+ * ENOMEM - memory allocation failure.
+ * ENIVAL - a parameter is passed as NULL that should not be or a problem
+ *   writing into the system.
+ */
+int tracefs_synth_create(struct tracefs_instance *instance,
+			 struct tracefs_synth *synth)
+{
+	char *synthetic_event;
+	char *start_hist = NULL;
+	char *end_hist = NULL;
+	int ret;
+
+	if (!synth) {
+		errno = EINVAL;
+		return -1;
+	}
+
+	synthetic_event = create_synthetic_event(synth);
+	if (!synthetic_event)
+		return -1;
+
+	ret = tracefs_instance_file_append(NULL, "synthetic_events",
+					   synthetic_event);
+	if (ret < 0)
+		goto free_synthetic;
+
+	start_hist = create_hist(synth->start_keys, synth->start_vars);
+	if (synth->start_filter) {
+		start_hist = append_string(start_hist, NULL, " if ");
+		start_hist = append_string(start_hist, NULL, synth->start_filter);
+	}
+	if (!start_hist)
+		goto remove_synthetic;
+
+	end_hist = create_end_hist(synth);
+	if (synth->end_filter) {
+		end_hist = append_string(end_hist, NULL, " if ");
+		end_hist = append_string(end_hist, NULL, synth->end_filter);
+	}
+	if (!end_hist)
+		goto remove_synthetic;
+
+	ret = tracefs_event_file_append(instance, synth->start_event->system,
+					synth->start_event->name,
+					"trigger", start_hist);
+	if (ret < 0)
+		goto remove_synthetic;
+
+	ret = tracefs_event_file_append(instance, synth->end_event->system,
+					synth->end_event->name,
+					"trigger", end_hist);
+	if (ret < 0)
+		goto remove_start_hist;
+
+	free(start_hist);
+	free(end_hist);
+
+	return 0;
+
+ remove_start_hist:
+	remove_hist(instance, synth->start_event, start_hist);
+ remove_synthetic:
+	free(end_hist);
+	free(start_hist);
+	remove_synthetic(synthetic_event);
+ free_synthetic:
+	free(synthetic_event);
+	return -1;
+}
+
+/**
+ * tracefs_synth_destroy - delete the synthetic event from the system
+ * @instance: The instance to modify the start and end events
+ * @synth: The tracefs_synth descriptor
+ *
+ * This will destroy a synthetic event created by tracefs_synth_create()
+ * with the same @instance and @synth.
+ *
+ * It will attempt to disable the synthetic event, but if other instances
+ * have it active, it is likely to fail, which will likely fail on
+ * all other parts of tearing down the synthetic event.
+ *
+ * Returns 0 on succes and -1 on error.
+ * On error, errno is set to:
+ * ENOMEM - memory allocation failure.
+ * ENIVAL - a parameter is passed as NULL that should not be or a problem
+ *   writing into the system.
+ */
+int tracefs_synth_destroy(struct tracefs_instance *instance,
+			  struct tracefs_synth *synth)
+{
+	char *synthetic_event;
+	char *hist;
+	int ret;
+
+	if (!synth) {
+		errno = EINVAL;
+		return -1;
+	}
+
+	/* Try to disable the event if possible */
+	tracefs_event_disable(instance, "synthetic", synth->name);
+
+	hist = create_end_hist(synth);
+	if (synth->end_filter) {
+		hist = append_string(hist, NULL, " if ");
+		hist = append_string(hist, NULL, synth->end_filter);
+	}
+	if (!hist)
+		return -1;
+	ret = remove_hist(instance, synth->end_event, hist);
+	free(hist);
+
+	hist = create_hist(synth->start_keys, synth->start_vars);
+	if (synth->start_filter) {
+		hist = append_string(hist, NULL, " if ");
+		hist = append_string(hist, NULL, synth->start_filter);
+	}
+	if (!hist)
+		return -1;
+
+	ret = remove_hist(instance, synth->start_event, hist);
+	free(hist);
+
+	synthetic_event = create_synthetic_event(synth);
+	if (!synthetic_event)
+		return -1;
+
+	ret = remove_synthetic(synthetic_event);
+
+	return ret ? -1 : 0;
+}
+
+/**
+ * tracefs_synth_show - show the command lines to create the synthetic event
+ * @seq: The trace_seq to store the command lines in
+ * @instance: The instance to modify the start and end events
+ * @synth: The tracefs_synth descriptor
+ *
+ * This will list the "echo" commands that are equivalent to what would
+ * be executed by the tracefs_synth_create() command.
+ *
+ * Returns 0 on succes and -1 on error.
+ * On error, errno is set to:
+ * ENOMEM - memory allocation failure.
+ */
+int tracefs_synth_show(struct trace_seq *seq,
+		       struct tracefs_instance *instance,
+		       struct tracefs_synth *synth)
+{
+	char *synthetic_event = NULL;
+	char *hist = NULL;
+	char *path;
+	int ret = -1;
+
+	if (!synth) {
+		errno = EINVAL;
+		return -1;
+	}
+
+	synthetic_event = create_synthetic_event(synth);
+	if (!synthetic_event)
+		return -1;
+
+	path = trace_find_tracing_dir();
+	if (!path)
+		goto out_free;
+
+	trace_seq_printf(seq, "echo '%s' > %s/synthetic_events\n",
+			 synthetic_event, path);
+
+	tracefs_put_tracing_file(path);
+	path = tracefs_instance_get_dir(instance);
+
+	hist = create_hist(synth->start_keys, synth->start_vars);
+	if (synth->start_filter) {
+		hist = append_string(hist, NULL, " if ");
+		hist = append_string(hist, NULL, synth->start_filter);
+	}
+	if (!hist)
+		goto out_free;
+
+	trace_seq_printf(seq, "echo '%s' > %s/events/%s/%s/trigger\n",
+			 hist, path, synth->start_event->system,
+			 synth->start_event->name);
+	free(hist);
+	hist = create_end_hist(synth);
+
+	if (synth->end_filter) {
+		hist = append_string(hist, NULL, " if ");
+		hist = append_string(hist, NULL, synth->end_filter);
+	}
+	if (!hist)
+		goto out_free;
+
+	trace_seq_printf(seq, "echo '%s' > %s/events/%s/%s/trigger\n",
+			 hist, path, synth->end_event->system,
+			 synth->end_event->name);
+
+	ret = 0;
+ out_free:
+	free(synthetic_event);
+	free(hist);
+	tracefs_put_tracing_file(path);
+	return ret;
+}
-- 
2.30.2

