Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B38FC4338F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 16 Aug 2021 21:40:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51FCE60EE4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 16 Aug 2021 21:40:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233399AbhHPVky (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 16 Aug 2021 17:40:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:36956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229987AbhHPVky (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 16 Aug 2021 17:40:54 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92F0460EE4;
        Mon, 16 Aug 2021 21:40:20 +0000 (UTC)
Date:   Mon, 16 Aug 2021 17:40:18 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        tom.zanussi@linux.intel.com
Subject: Re: [PATCH v4] [RFC] trace: Add kprobe on tracepoint
Message-ID: <20210816174018.4eefc045@oasis.local.home>
In-Reply-To: <20210813004448.51c7de69ce432d338f4d226b@kernel.org>
References: <20210811141433.1976072-1-tz.stoyanov@gmail.com>
        <20210813004448.51c7de69ce432d338f4d226b@kernel.org>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 13 Aug 2021 00:44:48 +0900
Masami Hiramatsu <mhiramat@kernel.org> wrote:

Tzvetomir's on PTO so I'm helping out (trying to get this into the next
merge window).

> Hi,
> 
> Here is my code review.
> 
> On Wed, 11 Aug 2021 17:14:33 +0300
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
> [...]
> > +
> > +static struct trace_eprobe *to_trace_eprobe(struct dyn_event *ev)
> > +{
> > +	return container_of(ev, struct trace_eprobe, devent);
> > +}
> > +
> > +static int trace_eprobe_find(struct trace_eprobe *ep)  
> 
> This function name is a bit easy to mislead. If I were you,
> I call it 'trace_eprobe_setup_event()'.

I agree the name is misleading.

> Or, I'll make it returns 'struct trace_event_call *' and set
> ep->event outside of this function. Moreover, I recommend you
> to call this before alloc_event_probe() and pass the result to it.
> e.g.
> 
> ... /* parse the target system and event */
> 
> event_call = find_and_get_event(sys_name, sys_event);
> if (!event_call)
>    goto error;
> 
> ep = alloc_event_probe(group, event, sys_name, sys_event, event_call, argc - 2);
> if (IS_ERR(ep))

To do the above, we'll need to take the event_mutex over both calls. I
can try that, and see what the lockdep fallout is ;-)


>    ...
> 
> > +{
> > +	struct trace_event_call *tp_event;
> > +	int ret = -ENOENT;
> > +	const char *name;
> > +
> > +	mutex_lock(&event_mutex);
> > +	list_for_each_entry(tp_event, &ftrace_events, list) {
> > +		if (tp_event->flags & TRACE_EVENT_FL_IGNORE_ENABLE)
> > +			continue;
> > +		if (!tp_event->class->system ||
> > +		    strcmp(ep->event_system, tp_event->class->system))
> > +			continue;
> > +		name = trace_event_name(tp_event);
> > +		if (!name ||
> > +		    strcmp(ep->event_name, name))
> > +			continue;
> > +		if (!try_module_get(tp_event->mod)) {
> > +			ret = -ENODEV;
> > +			break;
> > +		}  
> 
> BTW, this can lock the static events (because the module in where the
> event is locked), but can not lock the other dynamic events.
> Maybe we need 2 more patches.
> 
> 1) introduce TRACE_EVENT_FL_PROBE and set the flag in alloc_trace_k/uprobe().
>    (and eprobe will skip it)

I'm fine with what you suggest here.


> 2) introduce refcount for the trace_event_call, which prevent removing
>    synthetic event.

I rather not add another field to trace_event_call. There's one for
every event, which we have over a thousand events. Every field we add
to that structure adds more bloat to the kernel memory footprint.

Perhaps we can have a dynamic event structure that encapsulates the
trace_event_call used by kprobes, et.al. and add the counter there? I
would require changes like:

static inline struct dymanic_event_call *
dynamic_event_from_trace_event(struct trace_event_call *call)
{
	WARN_ON_ONCE(!(call->flags & TRACE_EVENT_FL_DYN_EVENT));
	return container_of(call, struct dynamic_event_call, event);
}

[..]

static inline struct trace_probe_event *
trace_probe_event_from_call(struct trace_event_call *event_call)
{
	struct dynamic_event_call *de = dynamic_event_from_trace_event(call);
	return container_of(event_call, struct trace_probe_event, de);
}

Or maybe I can make the mod a union. As it's not needed for dynamic
events, perhaps I can use the void *mod as:

struct trace_event_call {
	[..]
	union {
		void		*mod;
		atomic_t	dynamic_ref_count;
	};

??

If we place a kprobe on module text, I'm guessing the kprobe itself
handles that module logic, we don't need to do it on the trace event.

> 
> 
> > +		ep->event = tp_event;
> > +		ret = 0;
> > +		break;
> > +	}
> > +	mutex_unlock(&event_mutex);
> > +
> > +	return ret;
> > +}
> > +
> > +static int eprobe_dyn_event_create(const char *raw_command)
> > +{
> > +	return trace_probe_create(raw_command, __trace_eprobe_create);
> > +}
> > +  
> [...]
> > +
> > +static struct trace_eprobe *alloc_event_probe(const char *group,
> > +					      const char *event,
> > +					      const char *sys_name,
> > +					      const char *sys_event,
> > +					      int nargs)
> > +{
> > +	struct trace_eprobe *ep;
> > +	int ret = -ENOMEM;
> > +
> > +	ep = kzalloc(SIZEOF_TRACE_EPROBE(nargs), GFP_KERNEL);
> > +	if (!ep)
> > +		goto error;
> > +	ep->event_name = kstrdup(sys_event, GFP_KERNEL);
> > +	if (!ep->event_name)
> > +		goto error;
> > +	ep->event_system = kstrdup(sys_name, GFP_KERNEL);
> > +	if (!ep->event_system)
> > +		goto error;
> > +
> > +	ret = trace_probe_init(&ep->tp, event, group, false);
> > +	if (ret < 0)
> > +		goto error;
> > +
> > +	dyn_event_init(&ep->devent, &eprobe_dyn_event_ops);
> > +	return ep;
> > +error:
> > +	trace_event_probe_cleanup(ep);
> > +	return ERR_PTR(ret);
> > +}
> > +
> > +static int trace_eprobe_tp_arg_find(struct trace_eprobe *ep, int i)  
> 
> I think 'trace_eprobe_tp_arg_update()' will be better name.
> Also, 'if (ep->tp.args[i].code->op == FETCH_OP_TP_ARG)' check
> is moved inside in this function for hiding inside of the tp.args.

Will update.

> 
> > +{
> > +	struct probe_arg *parg = &ep->tp.args[i];
> > +	struct ftrace_event_field *field;
> > +	struct list_head *head;
> > +
> > +	head = trace_get_fields(ep->event);
> > +	list_for_each_entry(field, head, link) {
> > +		if (!strcmp(parg->code->data, field->name)) {
> > +			kfree(parg->code->data);
> > +			parg->code->data = field;
> > +			return 0;
> > +		}
> > +	}
> > +	kfree(parg->code->data);
> > +	parg->code->data = NULL;
> > +	return -ENOENT;
> > +}
> > +
> > +static int kprobe_event_define_fields(struct trace_event_call *event_call)  
> 
> you meant 'eprobe_event_define_fields()' ? :)

Yes, and I'll also rename the subject of the patch. As we are adding
probes to tracepoints not kprobes.

> 
> > +{
> > +	int ret;
> > +	struct kprobe_trace_entry_head field;
> > +	struct trace_probe *tp;
> > +
> > +	tp = trace_probe_primary_from_call(event_call);
> > +	if (WARN_ON_ONCE(!tp))
> > +		return -ENOENT;
> > +
> > +	DEFINE_FIELD(unsigned long, ip, FIELD_STRING_IP, 0);  
> 
> Would you really need this 'ip' field? I think you can record the

No we do not. Will remove.

> original event ID (call->event.type) instead of ip.

Good idea about the "id" instead of "ip".

> 
> > +
> > +	return traceprobe_define_arg_fields(event_call, sizeof(field), tp);
> > +}
> > +
> > +static struct trace_event_fields eprobe_fields_array[] = {
> > +	{ .type = TRACE_FUNCTION_TYPE,
> > +	  .define_fields = kprobe_event_define_fields },  
> 
> Ditto.
> 

Agreed.

> > +	{}
> > +};
> > +
> > +/* Event entry printers */
> > +static enum print_line_t
> > +print_eprobe_event(struct trace_iterator *iter, int flags,
> > +		   struct trace_event *event)
> > +{
> > +	struct kprobe_trace_entry_head *field;
> > +	struct trace_seq *s = &iter->seq;
> > +	struct trace_probe *tp;
> > +
> > +	field = (struct kprobe_trace_entry_head *)iter->ent;
> > +	tp = trace_probe_primary_from_call(
> > +		container_of(event, struct trace_event_call, event));
> > +	if (WARN_ON_ONCE(!tp))
> > +		goto out;
> > +
> > +	trace_seq_printf(s, "%s: (", trace_probe_name(tp));
> > +
> > +	if (!seq_print_ip_sym(s, field->ip, flags | TRACE_ITER_SYM_OFFSET))
> > +		goto out;  
> 
> Here, you can show the original event name from the event ID.

OK.

> 
> > +
> > +	trace_seq_putc(s, ')');
> > +
> > +	if (print_probe_args(s, tp->args, tp->nr_args,
> > +			     (u8 *)&field[1], field) < 0)
> > +		goto out;
> > +
> > +	trace_seq_putc(s, '\n');
> > + out:
> > +	return trace_handle_return(s);
> > +}
> > +
> > +static unsigned long get_event_field(struct fetch_insn *code, void *rec)
> > +{
> > +	struct ftrace_event_field *field = code->data;
> > +	unsigned long val;
> > +	void *addr;
> > +
> > +	addr = rec + field->offset;
> > +
> > +	switch (field->size) {
> > +	case 1:
> > +		if (field->is_signed)
> > +			val = *(char *)addr;
> > +		else
> > +			val = *(unsigned char *)addr;
> > +		break;
> > +	case 2:
> > +		if (field->is_signed)
> > +			val = *(short *)addr;
> > +		else
> > +			val = *(unsigned short *)addr;
> > +		break;
> > +	case 4:
> > +		if (field->is_signed)
> > +			val = *(int *)addr;
> > +		else
> > +			val = *(unsigned int *)addr;
> > +		break;
> > +	default:
> > +		if (field->is_signed)
> > +			val = *(long *)addr;
> > +		else
> > +			val = *(unsigned long *)addr;
> > +		break;
> > +	}
> > +	return val;
> > +}
> > +
> > +static int get_eprobe_size(struct trace_probe *tp, void *rec)
> > +{
> > +	struct probe_arg *arg;
> > +	int i, len, ret = 0;
> > +
> > +	for (i = 0; i < tp->nr_args; i++) {
> > +		arg = tp->args + i;
> > +		if (unlikely(arg->dynamic)) {
> > +			unsigned long val;
> > +
> > +			val = get_event_field(arg->code, rec);
> > +			len = process_fetch_insn_bottom(arg->code + 1, val, NULL, NULL);
> > +			if (len > 0)
> > +				ret += len;
> > +		}
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> > +/* Kprobe specific fetch functions */  
> [...]
> > +static nokprobe_inline int
> > +probe_mem_read(void *dest, void *src, size_t size)
> > +{
> > +#ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
> > +	if ((unsigned long)src < TASK_SIZE)
> > +		return probe_mem_read_user(dest, src, size);
> > +#endif
> > +	return copy_from_kernel_nofault(dest, src, size);
> > +}  
> 
> Hmm, these "fetch_args for kernel" APIs should finally unified with
> kprobe events. But at this step, this is good.

Agreed. For later patches though.

> 
> > +
> > +/* eprobe handler */
> > +static inline void
> > +__eprobe_trace_func(struct eprobe_data *edata, void *rec)
> > +{
> > +	struct kprobe_trace_entry_head *entry;
> > +	struct trace_event_call *call = trace_probe_event_call(&edata->ep->tp);
> > +	struct trace_event_buffer fbuffer;
> > +	int dsize;
> > +
> > +	WARN_ON(call != edata->file->event_call);
> > +
> > +	if (trace_trigger_soft_disabled(edata->file))
> > +		return;
> > +
> > +	fbuffer.trace_ctx = tracing_gen_ctx();
> > +	fbuffer.trace_file = edata->file;
> > +
> > +	dsize = get_eprobe_size(&edata->ep->tp, rec);
> > +	fbuffer.regs = NULL;
> > +
> > +	fbuffer.event =
> > +		trace_event_buffer_lock_reserve(&fbuffer.buffer, edata->file,
> > +					call->event.type,
> > +					sizeof(*entry) + edata->ep->tp.size + dsize,
> > +					fbuffer.trace_ctx);
> > +	if (!fbuffer.event)
> > +		return;
> > +
> > +	entry = fbuffer.entry = ring_buffer_event_data(fbuffer.event);
> > +	entry->ip = 0;  
> 
> Here, you can trace edata->ep->event->event.type instead of 0.

OK.

> 
> > +	store_trace_args(&entry[1], &edata->ep->tp, rec, sizeof(*entry), dsize);
> > +
> > +	trace_event_buffer_commit(&fbuffer);
> > +}
> > +
> > +/*
> > + * The event probe implementation uses event triggers to get access to
> > + * the event it is attached to, but is not an actual trigger. The below
> > + * functions are just stubs to fulfill what is needed to use the trigger
> > + * infrastructure.
> > + */  
> 
> OK, I got it. So eprobe is implemented on the trigger action framework.
> 
> [...]
> > +
> > +static int enable_eprobe(struct trace_eprobe *ep,
> > +			 struct trace_event_file *eprobe_file)
> > +{
> > +	struct event_trigger_data *trigger;
> > +	struct trace_event_file *file;
> > +	struct trace_array *tr = eprobe_file->tr;
> > +
> > +	file = find_event_file(tr, ep->event_system, ep->event_name);
> > +	if (!file)
> > +		return -ENOENT;
> > +	trigger = new_eprobe_trigger(ep, eprobe_file);
> > +	if (IS_ERR(trigger))
> > +		return PTR_ERR(trigger);
> > +
> > +	list_add_tail_rcu(&trigger->list, &file->triggers);
> > +
> > +	trace_event_trigger_enable_disable(file, 1);
> > +	update_cond_flag(file);
> > +
> > +	return 0;
> > +}
> > +
> > +static struct trace_event_functions eprobe_funcs = {
> > +	.trace		= print_eprobe_event
> > +};
> > +
> > +static int disable_eprobe(struct trace_eprobe *ep,
> > +			  struct trace_array *tr)
> > +{
> > +	struct event_trigger_data *trigger;
> > +	struct trace_event_file *file;
> > +	struct eprobe_data *edata;
> > +
> > +	file = find_event_file(tr, ep->event_system, ep->event_name);
> > +	if (!file)
> > +		return -ENOENT;
> > +
> > +	list_for_each_entry(trigger, &file->triggers, list) {
> > +		if (!(trigger->flags & EVENT_TRIGGER_FL_PROBE))
> > +			continue;
> > +		edata = trigger->private_data;
> > +		if (edata->ep == ep)
> > +			break;
> > +	}
> > +	if (list_entry_is_head(trigger, &file->triggers, list))
> > +		return -ENODEV;
> > +
> > +	list_del_rcu(&trigger->list);
> > +
> > +	trace_event_trigger_enable_disable(file, 0);
> > +	update_cond_flag(file);
> > +	return 0;
> > +}
> > +
> > +static int enable_trace_eprobe(struct trace_event_call *call,
> > +			       struct trace_event_file *file)
> > +{
> > +	struct trace_probe *pos, *tp;
> > +	struct trace_eprobe *ep;
> > +	bool enabled;
> > +	int ret = 0;
> > +
> > +	tp = trace_probe_primary_from_call(call);
> > +	if (WARN_ON_ONCE(!tp))
> > +		return -ENODEV;
> > +	enabled = trace_probe_is_enabled(tp);
> > +
> > +	/* This also changes "enabled" state */
> > +	if (file) {
> > +		ret = trace_probe_add_file(tp, file);
> > +		if (ret)
> > +			return ret;
> > +	} else
> > +		trace_probe_set_flag(tp, TP_FLAG_PROFILE);
> > +
> > +	if (enabled)
> > +		return 0;
> > +
> > +	list_for_each_entry(pos, trace_probe_probe_list(tp), list) {
> > +		ep = container_of(pos, struct trace_eprobe, tp);
> > +		ret = enable_eprobe(ep, file);
> > +		if (ret)
> > +			break;
> > +		enabled = true;
> > +	}
> > +
> > +	if (ret) {
> > +		/* Failed to enable one of them. Roll back all */
> > +		if (enabled)
> > +			disable_eprobe(ep, file->tr);
> > +		if (file)
> > +			trace_probe_remove_file(tp, file);
> > +		else
> > +			trace_probe_clear_flag(tp, TP_FLAG_PROFILE);
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> > +static int disable_trace_eprobe(struct trace_event_call *call,
> > +				struct trace_event_file *file)
> > +{
> > +	struct trace_probe *pos, *tp;
> > +	struct trace_eprobe *ep;
> > +
> > +	tp = trace_probe_primary_from_call(call);
> > +	if (WARN_ON_ONCE(!tp))
> > +		return -ENODEV;
> > +
> > +	if (file) {
> > +		if (!trace_probe_get_file_link(tp, file))
> > +			return -ENOENT;
> > +		if (!trace_probe_has_single_file(tp))
> > +			goto out;
> > +		trace_probe_clear_flag(tp, TP_FLAG_TRACE);
> > +	} else
> > +		trace_probe_clear_flag(tp, TP_FLAG_PROFILE);
> > +
> > +	if (!trace_probe_is_enabled(tp)) {
> > +		list_for_each_entry(pos, trace_probe_probe_list(tp), list) {
> > +			ep = container_of(pos, struct trace_eprobe, tp);
> > +			disable_eprobe(ep, file->tr);
> > +		}
> > +	}
> > +
> > + out:
> > +	if (file)
> > +		/*
> > +		 * Synchronization is done in below function. For perf event,
> > +		 * file == NULL and perf_trace_event_unreg() calls
> > +		 * tracepoint_synchronize_unregister() to ensure synchronize
> > +		 * event. We don't need to care about it.
> > +		 */
> > +		trace_probe_remove_file(tp, file);
> > +
> > +	return 0;
> > +}
> > +
> > +static int eprobe_register(struct trace_event_call *event,
> > +			   enum trace_reg type, void *data)
> > +{
> > +	struct trace_event_file *file = data;
> > +
> > +	switch (type) {
> > +	case TRACE_REG_REGISTER:
> > +		return enable_trace_eprobe(event, file);
> > +	case TRACE_REG_UNREGISTER:
> > +		return disable_trace_eprobe(event, file);
> > +#ifdef CONFIG_PERF_EVENTS
> > +	case TRACE_REG_PERF_REGISTER:
> > +	case TRACE_REG_PERF_UNREGISTER:  
> 
> Doesn't this support perf? In that case, you can simplify enable_trace_eprobe()
> and disable_trace_eprobe(), because 'file' is always not NULL.

It should support perf. We just haven't tested it yet ;-)

Perhaps we'll add perf support as a separate patch.

> 
> > +	case TRACE_REG_PERF_OPEN:
> > +	case TRACE_REG_PERF_CLOSE:
> > +	case TRACE_REG_PERF_ADD:
> > +	case TRACE_REG_PERF_DEL:
> > +		return 0;
> > +#endif
> > +	}
> > +	return 0;
> > +}
> > +
> > +static inline void init_trace_eprobe_call(struct trace_eprobe *ep)
> > +{
> > +	struct trace_event_call *call = trace_probe_event_call(&ep->tp);
> > +
> > +	call->flags = TRACE_EVENT_FL_EPROBE;
> > +	call->event.funcs = &eprobe_funcs;
> > +	call->class->fields_array = eprobe_fields_array;
> > +	call->class->reg = eprobe_register;
> > +}
> > +
> > +static int __trace_eprobe_create(int argc, const char *argv[])
> > +{
> > +	/*
> > +	 * Argument syntax:
> > +	 *      e[:[GRP/]ENAME] SYSTEM.EVENT [FETCHARGS]  
> 
> Ah, OK. ENAME is also omittable.
> 
> 
> > +	 * Fetch args:
> > +	 *  <name>=$<field>[:TYPE]
> > +	 */
> > +	const char *event = NULL, *group = EPROBE_EVENT_SYSTEM;
> > +	unsigned int flags = TPARG_FL_KERNEL | TPARG_FL_TPOINT;
> > +	const char *sys_event = NULL, *sys_name = NULL;
> > +	struct trace_eprobe *ep = NULL;
> > +	char buf1[MAX_EVENT_NAME_LEN];
> > +	char buf2[MAX_EVENT_NAME_LEN];
> > +	char *tmp = NULL;
> > +	int ret = 0;
> > +	int i;
> > +
> > +	if (argc < 2)
> > +		return -ECANCELED;
> > +
> > +	trace_probe_log_init("event_probe", argc, argv);
> > +
> > +	event = strchr(&argv[0][1], ':');
> > +	if (event) {
> > +		event++;
> > +		ret = traceprobe_parse_event_name(&event, &group, buf1,
> > +						  event - argv[0], '/');
> > +		if (ret)
> > +			goto parse_error;
> > +	} else {
> > +		strscpy(buf1, argv[1], MAX_EVENT_NAME_LEN);
> > +		sanitize_event_name(buf1);
> > +		event = buf1;
> > +	}
> > +	if (!is_good_name(event) || !is_good_name(group))
> > +		goto parse_error;
> > +
> > +	sys_event = argv[1];
> > +	ret = traceprobe_parse_event_name(&sys_event, &sys_name, buf2,
> > +					  sys_event - argv[1], '.');
> > +	if (ret || !sys_name)
> > +		goto parse_error;
> > +	if (!is_good_name(sys_event) || !is_good_name(sys_name))
> > +		goto parse_error;
> > +	ep = alloc_event_probe(group, event, sys_name, sys_event, argc - 2);
> > +	if (IS_ERR(ep)) {
> > +		ret = PTR_ERR(ep);
> > +		/* This must return -ENOMEM, else there is a bug */
> > +		WARN_ON_ONCE(ret != -ENOMEM);
> > +		goto error;	/* We know ep is not allocated */
> > +	}
> > +	ret = trace_eprobe_find(ep);
> > +	if (ret)
> > +		goto error;  
> 
> As I said above, this can be called before "alloc_event_probe()".

I'll take a look at implementing that.

> 
> > +
> > +	argc -= 2; argv += 2;
> > +	/* parse arguments */
> > +	for (i = 0; i < argc && i < MAX_TRACE_ARGS; i++) {
> > +		tmp = kstrdup(argv[i], GFP_KERNEL);
> > +		if (!tmp) {
> > +			ret = -ENOMEM;
> > +			goto error;
> > +		}
> > +		ret = traceprobe_parse_probe_arg(&ep->tp, i, tmp, flags);
> > +		if (ret == -EINVAL)
> > +			kfree(tmp);
> > +		if (ret)
> > +			goto error;	/* This can be -ENOMEM */
> > +		if (ep->tp.args[i].code->op == FETCH_OP_TP_ARG) {
> > +			ret = trace_eprobe_tp_arg_find(ep, i);  
> 
> Here, as I said above too, below code will be better encapsulated.
> 
>   /* (code->op check is done inside below function) */
>  ret = trace_eprobe_tp_arg_update(ep, i);
>  if (ret)
>     goto error;

OK.

> 
> > +			if (ret)
> > +				goto error;
> > +		}
> > +	}
> > +	ret = traceprobe_set_print_fmt(&ep->tp, false);
> > +	if (ret < 0)
> > +		goto error;
> > +	init_trace_eprobe_call(ep);
> > +	mutex_lock(&event_mutex);
> > +	ret = trace_probe_register_event_call(&ep->tp);
> > +	if (ret)
> > +		goto out_unlock;
> > +	ret = dyn_event_add(&ep->devent);
> > +out_unlock:
> > +	mutex_unlock(&event_mutex);
> > +	return ret;
> > +
> > +parse_error:
> > +	ret = -EINVAL;
> > +error:
> > +	trace_event_probe_cleanup(ep);
> > +	return ret;
> > +}
> > +
> > +/*
> > + * Register dynevent at core_initcall. This allows kernel to setup eprobe
> > + * events in postcore_initcall without tracefs.
> > + */
> > +static __init int trace_events_eprobe_init_early(void)
> > +{
> > +	int err = 0;
> > +
> > +	err = dyn_event_register(&eprobe_dyn_event_ops);
> > +	if (err)
> > +		pr_warn("Could not register eprobe_dyn_event_ops\n");
> > +
> > +	return err;
> > +}
> > +core_initcall(trace_events_eprobe_init_early);
> > diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
> > index 949ef09dc537..45f5392fb35c 100644
> > --- a/kernel/trace/trace_events_hist.c
> > +++ b/kernel/trace/trace_events_hist.c
> > @@ -66,7 +66,8 @@
> >  	C(EMPTY_SORT_FIELD,	"Empty sort field"),			\
> >  	C(TOO_MANY_SORT_FIELDS,	"Too many sort fields (Max = 2)"),	\
> >  	C(INVALID_SORT_FIELD,	"Sort field must be a key or a val"),	\
> > -	C(INVALID_STR_OPERAND,	"String type can not be an operand in expression"),
> > +	C(INVALID_STR_OPERAND,	"String type can not be an operand in expression"),  \
> > +	C(SYNTH_ON_EPROBE,	"Synthetic event on eprobe is not supported"),  
> 
> As I and Steve discussed, I think this can be allowed and loops should be
> detected and avoided in the other way. Anyway, this part will be better in
> the separated patch.

Agreed.

> [...]
> 
> > diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
> > index 15413ad7cef2..5a97317e91fb 100644
> > --- a/kernel/trace/trace_probe.c
> > +++ b/kernel/trace/trace_probe.c
> > @@ -227,12 +227,12 @@ int traceprobe_split_symbol_offset(char *symbol, long *offset)
> >  
> >  /* @buf must has MAX_EVENT_NAME_LEN size */
> >  int traceprobe_parse_event_name(const char **pevent, const char **pgroup,
> > -				char *buf, int offset)
> > +				char *buf, int offset, int delim)
> >  {
> >  	const char *slash, *event = *pevent;
> >  	int len;
> >  
> > -	slash = strchr(event, '/');
> > +	slash = strchr(event, delim);  
> 
> As I pointed another mail, I'm OK to use both '/' and '.' as delimiter for
> kprobes/uprobes too. But it must be a separated patch.

I'll update.

Thanks for taking the time with your review, it's been very valuable.

-- Steve
