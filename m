Return-Path: <SRS0=xGmm=LA=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39127 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbeHQMe7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 Aug 2018 08:34:59 -0400
Received: by mail-wr1-f67.google.com with SMTP id h10-v6so6512974wre.6
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Aug 2018 02:32:17 -0700 (PDT)
Subject: Re: [PATCH v3 2/3] kernel-shark-qt: Add I/O for configuration data.
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
References: <20180816150729.4680-1-y.karadz@gmail.com>
 <20180816150729.4680-2-y.karadz@gmail.com>
 <20180816145219.7e91e435@gandalf.local.home>
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <0a535d0f-333c-f002-970c-33c5a8937b05@gmail.com>
Date: Fri, 17 Aug 2018 12:32:13 +0300
MIME-Version: 1.0
In-Reply-To: <20180816145219.7e91e435@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Hi Steven

On 16.08.2018 21:52, Steven Rostedt wrote:
>> +	jfile_name = json_object_new_string(file);
>> +	jtime = json_object_new_int64(st.st_mtime);
> BTW, are you saving the timestamp to make sure the trace.dat file is
> the same? (assuming that the 'file' in question is trace.dat)
> 
> What if we want to use the same "session" for different trace.dat files?
> 


If the timestamp is different then the import will fail (see below).

If you really want to load the session with a different file you can 
hand-edit the Json file and make it match.


 >> +static bool kshark_trace_file_from_json(const char **file,
 >> +					struct json_object *jobj)
 >> +{
 >> +	struct json_object *jfile_name, *jtime;
 >> +	const char *file_str;
 >> +	struct stat st;
 >> +	int64_t time;
 >> +
 >> +	if (!jobj)
 >> +		return false;
 >> +
 >> +	if (!kshark_json_type_check(jobj, "kshark.data.config") ||
 >> +	    !json_object_object_get_ex(jobj, "file", &jfile_name) ||
 >> +	    !json_object_object_get_ex(jobj, "time", &jtime)) {
 >> +		fprintf(stderr,
 >> +			"Failed to retrieve data file from json_object.\n");
 >> +		return false;
 >> +	}
 >> +
 >> +	file_str = json_object_get_string(jfile_name);
 >> +	time = json_object_get_int64(jtime);
 >> +
 >> +	if (stat(file_str, &st) != 0) {
 >> +		fprintf(stderr, "Unable to find file %s\n", file_str);
 >> +		return false;
 >> +	}
 >> +
 >> +	if (st.st_mtime != time) {


Here we check the timestamp.


 >> +		fprintf(stderr,"Timestamp mismatch!\nFile %s", file_str);
 >> +		return false;
 >> +	}
 >> +
 >> +	*file = file_str;
 >> +
 >> +	return true;
 >> +}
 >> +
 >> +/**
 >> + * @brief Read the name of a trace data file and its timestamp from a
 >> + *	  Configuration document and check if such a file exists.
 >> + *	  If the file exists, open it.
 >> + *
 >> + * @param kshark_ctx: Input location for session context pointer.
 >> + * @param conf: Input location for the kshark_config_doc instance. 
Currently
 >> + *		only Json format is supported.
 >> + *
 >> + * @returns The name of the file on success. Else NULL.
 > 	s/on success. Else/on success, otherwise/
 >
 > There also needs to be a statement stating that "file" is an internal
 > element of @conf and should not be modified, and is undefined if @conf
 > is destroyed (freed).
 >
 >> + */
 >> +const char* kshark_import_trace_file(struct kshark_context *kshark_ctx,
 >> +				     struct kshark_config_doc *conf)
 >> +{
 >> +	const char *file = NULL;
 >> +	switch (conf->format) {
 >> +	case KS_CONFIG_JSON:
 >> +		if (kshark_trace_file_from_json(&file, conf->conf_doc))
 >> +			kshark_open(kshark_ctx, file);
 >> +
 >> +		break;
