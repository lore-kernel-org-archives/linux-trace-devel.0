Return-Path: <SRS0=eYsA=6L=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DD8AC54FCB
	for <linux-trace-devel@archiver.kernel.org>; Mon, 27 Apr 2020 14:46:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D3C620661
	for <linux-trace-devel@archiver.kernel.org>; Mon, 27 Apr 2020 14:46:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lF8V3zqW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgD0Oqx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 27 Apr 2020 10:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726539AbgD0Oqx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 27 Apr 2020 10:46:53 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15AB0C0610D5
        for <linux-trace-devel@vger.kernel.org>; Mon, 27 Apr 2020 07:46:53 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id g4so17890037ljl.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 27 Apr 2020 07:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1xG/crcwx0Nmk0uoSZJp3KBgxVdBRmV6U3AIvl9ifIo=;
        b=lF8V3zqWveo6Q/unmfVLe0xP7MsTltgFWssxIXRrNTKLmfTpGg/3aF0PiKNZR5k+kL
         GsBmpRxV9iYdFyJX0qtraRmO1YJce5J8iQv+7EW/QTdYO+LFgrw/zJwNJtnahY1Gyp8j
         QGFHdRYIP9zHHwp0rbC31JJOKH+vzkX3ZyFac1Smd7fjbLr0iuNmUyfqtIbNb2dfPZd0
         q0PfXWTb0cDNMmxXk2OS6yMBfSD6jJkeCmWuy8WEBu5gLPT4xMP7D8kJZoSc1Gffzz+a
         YUr1Tt2oBEHw6u/pB5dcC9+XyMUdkaIrdBhJF5WEqTEYUgJeeEiVP0DLLQj3SEHbCwGC
         Ovfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1xG/crcwx0Nmk0uoSZJp3KBgxVdBRmV6U3AIvl9ifIo=;
        b=AJf/MNoEMaCuXq7lv3BLJjc7WwhhEgw3zyWeVwNSwNY1VmgxZ8G83H10imcPXaLtdS
         PXwxXKbtCJGBfmoouATRUc53dTGeRDaR0saRw1pTfKb0etP5GEj/GvUUAPh1j+SylZFh
         X/a2qvHCQrcK+f0w8WqeMJL24kI4BscrtKLrxoxwaa5ko4ZRoK9bAYUtyxM8pCPIEi+K
         glsHVzgyRVDDxxyBm7CPvccN23asVaysoUiY78LM36LctHbl+j9bm/JpWQXextCqA7F1
         OxLtII1zVhVym9tp1dXCbPHqnCYzKWELaCOAt+t4Zxi+obGJ1W0CEw8lPME2/nEko5EG
         Ysog==
X-Gm-Message-State: AGi0PuYRXpVR+sid066Jw6Mm4l7RseQgd1/QNEebwqCiWGbhh3RotIDU
        EMqrFQdfNR6PKWUGDKXO7S2HUUWe5fA=
X-Google-Smtp-Source: APiQypKx0S/3Fbw8XDf4Y1m04FFfQz+gI5lfbmccj5IjMjV7f82/CfaUC3xWahWStLUy6NQLKWNL6g==
X-Received: by 2002:a2e:a58e:: with SMTP id m14mr14515902ljp.95.1587998811084;
        Mon, 27 Apr 2020 07:46:51 -0700 (PDT)
Received: from [192.168.0.106] ([84.40.73.119])
        by smtp.gmail.com with ESMTPSA id o23sm11408779ljh.63.2020.04.27.07.46.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2020 07:46:50 -0700 (PDT)
Subject: Re: [PATCH v4] kernel-shark-2.alpha: Restructure KVMCombo plugin to
 use CPU mapping information from the trace files
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
References: <20200424085418.576111-1-tz.stoyanov@gmail.com>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <56e5b4b6-2759-89cb-4c45-31606cca7a19@gmail.com>
Date:   Mon, 27 Apr 2020 17:46:48 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200424085418.576111-1-tz.stoyanov@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Applied.

Thanks a lot!
Yordan

On 24.04.20 г. 11:54 ч., Tzvetomir Stoyanov (VMware) wrote:
> From: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>
> 
> In the upcoming trace-cmd 2.9, extra information about host and guest tracing
> will be stored in the trace.dat files. Information about host PID - guest vCPU
> mapping will be saved in host trace file. This mapping is mandatory for KVMCombo
> plugin. Currently, the mapping is extracted for the tracing data.
> Getting the information from the trace files is more reliable and solves the use
> case with more than one guest.
> 
> Signed-off-by: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>
> ---
>   src/libkshark-tepdata.c  | 116 +++++++++++++++++++++++++++++
>   src/libkshark-tepdata.h  |  20 +++++
>   src/plugins/KVMCombo.cpp | 156 ++++++++++++++++-----------------------
>   src/plugins/KVMCombo.hpp |  16 ++--
>   4 files changed, 205 insertions(+), 103 deletions(-)
> 
> diff --git a/src/libkshark-tepdata.c b/src/libkshark-tepdata.c
> index f280e57..c2de817 100644
> --- a/src/libkshark-tepdata.c
> +++ b/src/libkshark-tepdata.c
> @@ -22,6 +22,7 @@
>   #include "tracefs/tracefs.h"
>   
>   // KernelShark
> +#include "libkshark.h"
>   #include "libkshark-plugin.h"
>   #include "libkshark-tepdata.h"
>   
> @@ -1293,3 +1294,118 @@ char **kshark_tracecmd_local_plugins()
>   {
>   	return tracefs_tracers(tracefs_get_tracing_dir());
>   }
> +
> +/**
> + * @brief Free an array, allocated by kshark_tracecmd_get_hostguest_mapping() API
> + *
> + *
> + * @param map: Array, allocated by kshark_tracecmd_get_hostguest_mapping() API
> + * @param count: Number of entries in the array
> + *
> + */
> +void kshark_tracecmd_free_hostguest_map(struct kshark_host_guest_map *map, int count)
> +{
> +	int i;
> +
> +	if (!map)
> +		return;
> +	for (i = 0; i < count; i++) {
> +		free(map[i].guest_name);
> +		free(map[i].cpu_pid);
> +		memset(&map[i], 0, sizeof(*map));
> +	}
> +	free(map);
> +}
> +
> +/**
> + * @brief Get mapping of guest VCPU to host task, running that VCPU.
> + *	  Array of mappings for each guest is allocated and returned
> + *	  in map input parameter.
> + *
> + *
> + * @param map: Returns allocated array of kshark_host_guest_map structures, each
> + *	       one describing VCPUs mapping of one guest.
> + *
> + * @return The number of entries in the *map array, or a negative error code on
> + *	   failure.
> + */
> +int kshark_tracecmd_get_hostguest_mapping(struct kshark_host_guest_map **map)
> +{
> +	struct kshark_host_guest_map *gmap = NULL;
> +	struct tracecmd_input *peer_handle = NULL;
> +	struct kshark_data_stream *peer_stream;
> +	struct tracecmd_input *guest_handle = NULL;
> +	struct kshark_data_stream *guest_stream;
> +	struct kshark_context *kshark_ctx = NULL;
> +	unsigned long long trace_id;
> +	const char *name;
> +	int vcpu_count;
> +	const int *cpu_pid;
> +	int *stream_ids;
> +	int i, j, k;
> +	int count = 0;
> +	int ret;
> +
> +	if (!map || !kshark_instance(&kshark_ctx))
> +		return -EFAULT;
> +	if (*map)
> +		return -EEXIST;
> +
> +	stream_ids = kshark_all_streams(kshark_ctx);
> +	for (i = 0; i < kshark_ctx->n_streams; i++) {
> +		guest_stream = kshark_get_data_stream(kshark_ctx, stream_ids[i]);
> +		if (!guest_stream || guest_stream->format != KS_TEP_DATA)
> +			continue;
> +		guest_handle = kshark_get_tep_input(guest_stream);
> +		if (!guest_handle)
> +			continue;
> +		trace_id = tracecmd_get_traceid(guest_handle);
> +		if (!trace_id)
> +			continue;
> +		for (j = 0; j < kshark_ctx->n_streams; j++) {
> +			if (stream_ids[i] == stream_ids[j])
> +				continue;
> +			peer_stream = kshark_get_data_stream(kshark_ctx, stream_ids[j]);
> +			if (!peer_stream || peer_stream->format != KS_TEP_DATA)
> +				continue;
> +			peer_handle = kshark_get_tep_input(peer_stream);
> +			if (!peer_handle)
> +				continue;
> +			ret = tracecmd_get_guest_cpumap(peer_handle, trace_id,
> +							&name, &vcpu_count, &cpu_pid);
> +			if (!ret && vcpu_count) {
> +				gmap = realloc(*map,
> +					       (count + 1) * sizeof(struct kshark_host_guest_map));
> +				if (!gmap)
> +					goto mem_error;
> +				*map = gmap;
> +				memset(&gmap[count], 0, sizeof(struct kshark_host_guest_map));
> +				count++;
> +				gmap[count - 1].guest_id = stream_ids[i];
> +				gmap[count - 1].host_id = stream_ids[j];
> +				gmap[count - 1].guest_name = strdup(name);
> +				if (!gmap[count - 1].guest_name)
> +					goto mem_error;
> +				gmap[count - 1].vcpu_count = vcpu_count;
> +				gmap[count - 1].cpu_pid = malloc(sizeof(int) * vcpu_count);
> +				if (!gmap[count - 1].cpu_pid)
> +					goto mem_error;
> +				for (k = 0; k < vcpu_count; k++)
> +					gmap[count - 1].cpu_pid[k] = cpu_pid[k];
> +				break;
> +			}
> +		}
> +	}
> +
> +	free(stream_ids);
> +	return count;
> +
> +mem_error:
> +	free(stream_ids);
> +	if (*map) {
> +		kshark_tracecmd_free_hostguest_map(*map, count);
> +		*map = NULL;
> +	}
> +
> +	return -ENOMEM;
> +}
> diff --git a/src/libkshark-tepdata.h b/src/libkshark-tepdata.h
> index 53f6aff..0b4b2e2 100644
> --- a/src/libkshark-tepdata.h
> +++ b/src/libkshark-tepdata.h
> @@ -59,6 +59,26 @@ struct tep_record;
>   ssize_t kshark_load_tep_records(struct kshark_context *kshark_ctx, int sd,
>   				struct tep_record ***data_rows);
>   
> +struct kshark_host_guest_map {
> +	/** ID of guest stream */
> +	int guest_id;
> +
> +	/** ID of host stream */
> +	int host_id;
> +
> +	/** Guest name */
> +	char *guest_name;
> +
> +	/** Number of guest's CPUs in *cpu_pid array */
> +	int vcpu_count;
> +
> +	/** Array of host task PIDs, index is the VCPU id */
> +	int *cpu_pid;
> +};
> +
> +void kshark_tracecmd_free_hostguest_map(struct kshark_host_guest_map *map, int count);
> +int kshark_tracecmd_get_hostguest_mapping(struct kshark_host_guest_map **map);
> +
>   #ifdef __cplusplus
>   }
>   #endif
> diff --git a/src/plugins/KVMCombo.cpp b/src/plugins/KVMCombo.cpp
> index 1ae03aa..30eac95 100644
> --- a/src/plugins/KVMCombo.cpp
> +++ b/src/plugins/KVMCombo.cpp
> @@ -69,20 +69,30 @@ KsVCPUCheckBoxWidget::KsVCPUCheckBoxWidget(QWidget *parent)
>   	_initTree();
>   }
>   
> -void KsVCPUCheckBoxWidget::update(int sdHost, VCPUVector vcpus)
> +void KsVCPUCheckBoxWidget::update(int GuestId,
> +				  kshark_host_guest_map *gMap, int gMapCount)
>   {
> -	int nVCPUs = vcpus.count();
>   	KsPlot::ColorTable colors;
> +	int j;
> +
> +	for (j = 0; j < gMapCount; j++)
> +		if (gMap[j].guest_id == GuestId)
> +			break;
> +	if (j == gMapCount)
> +		return;
>   
>   	_tree.clear();
> -	_id.resize(nVCPUs);
> -	_cb.resize(nVCPUs);
> +	_id.resize(gMap[j].vcpu_count);
> +	_cb.resize(gMap[j].vcpu_count);
>   	colors = KsPlot::getCPUColorTable();
>   
> -	for (int i = 0; i < nVCPUs; ++i) {
> +	for (int i = 0; i < gMap[j].vcpu_count; ++i) {
> +		QString strCPU = QLatin1String("vCPU ") + QString::number(i);
> +		strCPU += (QLatin1String("\t<") + QLatin1String(gMap[j].guest_name) + QLatin1Char('>'));
> +
>   		QTreeWidgetItem *cpuItem = new QTreeWidgetItem;
>   		cpuItem->setText(0, "  ");
> -		cpuItem->setText(1, QString("vCPU %1").arg(vcpus.at(i).second));
> +		cpuItem->setText(1, strCPU);
>   		cpuItem->setCheckState(0, Qt::Checked);
>   		cpuItem->setBackgroundColor(0, QColor(colors[i].r(),
>   						      colors[i].g(),
> @@ -168,26 +178,41 @@ KsComboPlotDialog::KsComboPlotDialog(QWidget *parent)
>   		this,			SLOT(_guestStreamChanged(const QString &)));
>   
>   	setLayout(&_topLayout);
> +
> +	_guestMapCount = 0;
> +	_guestMap = nullptr;
>   }
>   
> -void KsComboPlotDialog::update(int sdHost, VCPUVector vcpus)
> +KsComboPlotDialog::~KsComboPlotDialog()
> +{
> +	kshark_tracecmd_free_hostguest_map(_guestMap, _guestMapCount);
> +}
> +
> +void KsComboPlotDialog::update()
>   {
>   	kshark_context *kshark_ctx(nullptr);
> -	int sd, *streamIds;
> +	int ret;
> +	int sd;
> +	int i;
>   
>   	if (!kshark_instance(&kshark_ctx))
>   		return;
>   
> -	_sdHost = sdHost;
> -	_vcpus = vcpus;
> +	kshark_tracecmd_free_hostguest_map(_guestMap, _guestMapCount);
> +	_guestMap = nullptr;
> +	_guestMapCount = 0;
> +	ret = kshark_tracecmd_get_hostguest_mapping(&_guestMap);
> +	if (ret > 0)
> +		_guestMapCount = ret;
> +
>   	KsUtils::setElidedText(&_hostFileLabel,
> -			       kshark_ctx->stream[sdHost]->file,
> +			       kshark_ctx->stream[_guestMap[0].host_id]->file,
>   			       Qt::ElideLeft, LABEL_WIDTH);
>   
> -	streamIds = kshark_all_streams(kshark_ctx);
> -	for (int i = 0; i < kshark_ctx->n_streams; ++i) {
> -		sd = streamIds[i];
> -		if (sd == sdHost)
> +	_guestStreamComboBox.clear();
> +	for (i = 0; i < _guestMapCount; i++) {
> +		sd = _guestMap[i].guest_id;
> +		if (sd >= kshark_ctx->n_streams)
>   			continue;
>   
>   		_guestStreamComboBox.addItem(kshark_ctx->stream[sd]->file,
> @@ -200,8 +225,8 @@ void KsComboPlotDialog::update(int sdHost, VCPUVector vcpus)
>   				this,		&KsComboPlotDialog::_applyPress);
>   	}
>   
> -	_vcpuTree.update(sdHost, vcpus);
> -	free(streamIds);
> +	sd = _guestStreamComboBox.currentData().toInt();
> +	_vcpuTree.update(sd, _guestMap, _guestMapCount);
>   }
>   
>   void KsComboPlotDialog::_applyPress()
> @@ -210,6 +235,16 @@ void KsComboPlotDialog::_applyPress()
>   	QVector<int> allCombosVec;
>   	KsComboPlot combo(2);
>   	int nPlots(0);
> +	int GuestId;
> +	int j;
> +
> +	GuestId = _guestStreamComboBox.currentData().toInt();
> +	for (j = 0; j < _guestMapCount; j++)
> +		if (_guestMap[j].guest_id == GuestId)
> +			break;
> +	if (j == _guestMapCount)
> +		return;
> +
>   
>   	/*
>   	 * Disconnect _applyButton. This is done in order to protect
> @@ -218,17 +253,20 @@ void KsComboPlotDialog::_applyPress()
>   	disconnect(_applyButtonConnection);
>   
>   	for (auto const &i: cbVec) {
> +		if (i >= _guestMap[j].vcpu_count)
> +			continue;
> +
>   		allCombosVec.append(2);
>   
> -		combo[0]._streamId = _guestStreamComboBox.currentData().toInt();
> -		combo[0]._id = _vcpus.at(i).second;
> +		combo[0]._streamId = _guestMap[j].guest_id;
> +		combo[0]._id = i;
>   		combo[0]._type = KsPlot::KSHARK_CPU_DRAW |
>   				 KsPlot::KSHARK_GUEST_DRAW;
>   
>   		combo[0] >> allCombosVec;
>   
> -		combo[1]._streamId = _sdHost;
> -		combo[1]._id = _vcpus.at(i).first;
> +		combo[1]._streamId = _guestMap[j].host_id;
> +		combo[1]._id = _guestMap[j].cpu_pid[i];
>   		combo[1]._type = KsPlot::KSHARK_TASK_DRAW |
>   				 KsPlot::KSHARK_HOST_DRAW;
>   
> @@ -241,66 +279,8 @@ void KsComboPlotDialog::_applyPress()
>   
>   void KsComboPlotDialog::_guestStreamChanged(const QString &sdStr)
>   {
> -
> -}
> -
> -static int getVCPU(plugin_kvm_context *plugin_ctx,
> -		   kshark_trace_histo *histo,
> -		   int sdHost, int pid)
> -{
> -	int values[2] = {plugin_ctx->vm_entry_id, pid};
> -	const kshark_entry *entry;
> -	unsigned long long vcpu;
> -
> -	for (int b = 0; b < histo->n_bins; ++b) {
> -		entry = ksmodel_get_entry_front(histo,
> -						b, false,
> -						kshark_match_event_and_pid,
> -						sdHost, values,
> -						nullptr,
> -						nullptr);
> -		if (!entry)
> -			continue;
> -
> -		if (kshark_read_event_field(entry, "vcpu_id", &vcpu) >= 0)
> -			return vcpu;
> -	}
> -
> -	return -1;
> -}
> -
> -HostMap getVCPUPids(kshark_context *kshark_ctx, kshark_trace_histo *histo)
> -{
> -	int sd, n_vcpus, *streamIds, *pids;
> -	plugin_kvm_context *plugin_ctx;
> -	HostMap hMap;
> -
> -	streamIds = kshark_all_streams(kshark_ctx);
> -	for (int i = 0; i < kshark_ctx->n_streams; ++i) {
> -		sd = streamIds[i];
> -		plugin_ctx = get_kvm_context(sd);
> -		if (!plugin_ctx)
> -			continue;
> -
> -		/* This stream contains KVM events. */
> -		n_vcpus = plugin_ctx->vcpu_pids->count;
> -		if (n_vcpus) {
> -			VCPUVector vcpus(n_vcpus);
> -			pids = kshark_hash_ids(plugin_ctx->vcpu_pids);
> -			for (int j = 0; j < n_vcpus; ++j) {
> -				vcpus[j].first = pids[j];
> -				vcpus[j].second = getVCPU(plugin_ctx,
> -							  histo,
> -							  sd, pids[j]);
> -			}
> -
> -			free(pids);
> -			hMap[sd] = vcpus;
> -		}
> -	}
> -
> -	free(streamIds);
> -	return hMap;
> +	int GuestId = _guestStreamComboBox.currentData().toInt();
> +	_vcpuTree.update(GuestId, _guestMap, _guestMapCount);
>   }
>   
>   KsComboPlotDialog dialog;
> @@ -309,18 +289,11 @@ QMetaObject::Connection dialogConnection;
>   static void showDialog(KsMainWindow *ks)
>   {
>   	kshark_context *kshark_ctx(nullptr);
> -	kshark_trace_histo *histo;
> -	VCPUVector vcpus;
> -	HostMap hMap;
> -	int sdHost;
>   
>   	if (!kshark_instance(&kshark_ctx))
>   		return;
>   
> -	histo = ks->graphPtr()->glPtr()->model()->histo();
> -	hMap = getVCPUPids(kshark_ctx, histo);
> -
> -	if (kshark_ctx->n_streams < 2 || hMap.count() != 1) {
> +	if (kshark_ctx->n_streams < 2) {
>   		QString err("Data from one Host and at least one Guest is required.");
>   		QMessageBox msgBox;
>   		msgBox.critical(nullptr, "Error", err);
> @@ -328,10 +301,7 @@ static void showDialog(KsMainWindow *ks)
>   		return;
>   	}
>   
> -	sdHost = hMap.begin().key();
> -	vcpus = hMap.begin().value();
> -
> -	dialog.update(sdHost, vcpus);
> +	dialog.update();
>   
>   	if (!dialogConnection) {
>   		dialogConnection =
> diff --git a/src/plugins/KVMCombo.hpp b/src/plugins/KVMCombo.hpp
> index b47f557..ecb9aeb 100644
> --- a/src/plugins/KVMCombo.hpp
> +++ b/src/plugins/KVMCombo.hpp
> @@ -15,10 +15,6 @@
>   #include "KsMainWindow.hpp"
>   #include "KsWidgetsLib.hpp"
>   
> -typedef QVector<QPair<int, int>> VCPUVector;
> -
> -typedef QMap<int, VCPUVector> HostMap;
> -
>   /**
>    * The KsVCPUCheckBoxWidget class provides a widget for selecting CPU plots to
>    * show.
> @@ -27,7 +23,8 @@ struct KsVCPUCheckBoxWidget : public KsWidgetsLib::KsCheckBoxTreeWidget
>   {
>   	explicit KsVCPUCheckBoxWidget(QWidget *parent = nullptr);
>   
> -	void update(int sdHost, VCPUVector vcpus);
> +	void update(int GuestId,
> +		    struct kshark_host_guest_map *gMap, int gMapCount);
>   };
>   
>   /**
> @@ -39,17 +36,16 @@ class KsComboPlotDialog : public QDialog
>   	Q_OBJECT
>   public:
>   	explicit KsComboPlotDialog(QWidget *parent = nullptr);
> -
> -	void update(int sdHost, VCPUVector vcpus);
> +	~KsComboPlotDialog();
> +	void update();
>   
>   signals:
>   	/** Signal emitted when the "Apply" button is pressed. */
>   	void apply(int sd, QVector<int>);
>   
>   private:
> -	int				_sdHost;
> -
> -	VCPUVector			_vcpus;
> +	int				_guestMapCount;
> +	struct kshark_host_guest_map 	*_guestMap;
>   
>   	KsVCPUCheckBoxWidget		_vcpuTree;
>   
> 
